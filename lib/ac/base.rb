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

     def authenticate! options
      if access_token
        options[:headers] ||= {}
        options[:headers]["Authorization"] = "Bearer #{access_token}"
      end
     end

    %i[get post put patch delete].each do |http_verb|
      define_method :"#{http_verb}_request" do |path, options = {}|
        options[:method] = http_verb
        authenticate!(options) unless options.delete(:skip_authentication)
        Typhoeus::Request.new url(path), options
      end

      define_method http_verb do |path, options = {}, &block|
        retries_count ||= 0

        response = send(:"#{http_verb}_request", path, options).run
        Database.save_request response, class_name: self.class.name if self.class::SAVE_RESPONSES

        if block
          unless run_block_validation(AcObject.from_response(response), block)
            if retries_count < self.class::MAX_RETRIES
              sleep(2**retries_count)
              retries_count += 1
              redo
            else
              raise BlockValidationError.new(AcObject.from_response(response))
            end
          end
        else
          unless response.success?
            if can_retry?(response) && retries_count < self.class::MAX_RETRIES
              sleep(2**retries_count)
              retries_count += 1
              redo
            else
              raise AcError.from_response(AcObject.from_response(response))
            end
          end
        end
        return AcObject.from_response(response)
      end
    end

    def run_block_validation response, block
      block.call response
    rescue StandardError => e
      false
    end

    def can_retry? response
      response.timed_out? || response.code == 0 || response.code == 429 || response.code >= 500
    end
  end
end
