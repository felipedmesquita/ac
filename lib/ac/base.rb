module Ac
  class Base
    MAX_RETRIES = 3
    SAVE_RESPONSES = false

    attr_reader :token_expires_at
    def initialize access_token = nil
      @access_token = access_token
    end

    def access_token
      refresh_token if should_refresh?
      @access_token
    end

    def should_refresh?
      return false unless respond_to?(:refresh_token)
      @access_token.blank? || @token_expires_at&.past?
    end

    def url path
      if path.start_with?("http://") || path.start_with?("https://")
        path
      else
        File.join(self.class::BASE_URL, path)
      end
    end

    def default_options
      {
        headers: {
          "Content-Type" => "application/json",
          "x-idempotency-key" => SecureRandom.uuid
        }
      }
    end

    def authenticate! options
      if access_token
        options[:headers] ||= {}
        options[:headers]["Authorization"] = "Bearer #{access_token}"
      end
    end

    %i[get post put patch delete].each do |http_verb|
      define_method :"#{http_verb}_request" do |path, options = {}|
        options.symbolize_keys!
        options[:method] = http_verb
        options = default_options.deep_merge(options) if default_options
        authenticate!(options) unless options.delete(:skip_authentication)
        if options[:body]
          options[:body] = JSON.dump(options[:body]) if options[:body].is_a?(Hash) && options.dig(:headers, "Content-Type") == "application/json"
        end
        Typhoeus::Request.new url(path), options
      end

      define_method http_verb do |path, options = {}, &block|
        options.symbolize_keys!
        request = send(:"#{http_verb}_request", path, options)
        return request if caller_locations.map(&:label).include? "Ac::Base#method_missing"

        for retry_number in 0..MAX_RETRIES
          response = request.run
          Database.save_request response, class_name: self.class.name if self.class::SAVE_RESPONSES
          ac_object = AcObject.from_response(response)
          if validate(ac_object, block)
            return ac_object
          else
            break unless block || can_retry?(ac_object.response)
            sleep(2**retry_number)
          end
        end

        raise AcError.from_response(ac_object)

      end
    end

    def validate ac_object, block=nil
      if block
        block.call ac_object rescue false
      else
        ac_object.response.success?
      end
    end

    def can_retry? response
      response.timed_out? || response.code == 0 || response.code == 429 || response.code >= 500
    end

    def respond_to_missing? method_name, ...
      client_method = method_name.to_s.delete_suffix!("_request")
      client_method && respond_to?(client_method)
    end

    def method_missing method_name, ...
      if respond_to_missing? method_name
        send(method_name.to_s.delete_suffix("_request"), ...)
      else
        super
      end
    end

  end
end
