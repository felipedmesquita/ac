module Ac
  class Base
    MAX_RETRIES = 3
    SAVE_RESPONSES = false

    attr_reader :access_token
    def initialize(access_token = nil)
      @access_token = access_token
    end

    def url(path)
      if path.start_with?("http://") || path.start_with?("https://")
        path
      else
        File.join(self.class::BASE_URL, path)
      end
    end

     def authenticate!(options)
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
        Database.save_request(response, class_name: self.class.name, retries_count: retries_count)

        if validate_response(response, block)
          response
        else
          if should_retry(response) && retries_count <= self.class::MAX_RETRIES
            retries_count += 1
            redo
          end
          raise AcError.from_response(response)
        end
      end
    end

    def validate_response(response, block = nil)
      if block
      begin
      block.call(response)
      rescue
        false
      end
      else
        response.success?
      end
    end

    def should_retry(response)
      response.code >= 429 || response.code == 0
    end
  end
end
