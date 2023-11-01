module Ac
  module JsonPatch
    def json
      JSON.parse body
    rescue JSON::ParserError
      nil
    end
  end
end
