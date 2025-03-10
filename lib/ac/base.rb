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
        if block || response.code == 429 || response.code.between?(500, 599)
          begin
            raise unless block.call(response)
            Database.save_request(response, class_name: self.class.name, retries_count: retries_count) if self.class::SAVE_RESPONSES
          rescue
            Database.save_request(response, class_name: self.class.name + "_errors", retries_count: retries_count) if self.class::SAVE_RESPONSES
            retries_count += 1 # standard:disable Lint/UselessAssignment
            if retries_count <= self.class::MAX_RETRIES
              sleep(2**retries_count)  # Exponential backoff
              redo
            end
          end
        elsif self.class::SAVE_RESPONSES
          Database.save_request(response, class_name: self.class.name, retries_count: retries_count)
        end
        response
      end
    end
  end
end
