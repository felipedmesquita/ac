module Ac
  class Base
    MAX_RETRIES = 3
    SAVE_RESPONSES = false

    attr_reader :access_token
    def initialize access_token = nil
      @access_token = access_token
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
        raise "Too many retries" if retries_count > self.class::MAX_RETRIES
        # puts "Requesting #{path}, retry number #{retries_count}"
        response = send(:"#{http_verb}_request", path, options).run

        if block
          begin
            raise unless block.call(response)
            Database.save_request response, class_name: self.class.name if self.class::SAVE_RESPONSES
          rescue
            Database.save_request(response, class_name: self.class.name + "_errors") if self.class::SAVE_RESPONSES
            retries_count += 1 # standard:disable Lint/UselessAssignment
            sleep(2**retries_count)  # Exponential backoff
            redo
          end
        elsif self.class::SAVE_RESPONSES
          Database.save_request response, class_name: self.class.name
        end

        response
      end
    end
  end
end
