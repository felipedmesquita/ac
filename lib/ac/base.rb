module Ac
  class Base
    MAX_RETRIES = 3

    attr_reader :access_token
    def initialize access_token = nil
      @access_token = access_token
    end

    def url path
      File.join(self.class::BASE_URL, path)
    end

    %i[get post put patch delete].each do |http_verb|
      define_method "#{http_verb}_request" do |path, options = {}|
        options[:method] = http_verb
        if access_token
          options[:headers] ||= {}
          options[:headers]["Authorization"] = "Bearer #{access_token}"
        end
        Typhoeus::Request.new url(path), options
      end

      define_method http_verb do |path, options = {}, &block|
        retries_count ||= 0
        raise "Too many retries" if retries_count > MAX_RETRIES
        # puts "Requesting #{path}, retry number #{retries_count}"
        response = send("#{http_verb}_request", path, options).run

        if block
          begin
            raise unless block.call(response)
          rescue
            retries_count += 1 # standard:disable Lint/UselessAssignment
            redo
          end
        end

        response
      end
    end
  end
end
