# frozen_string_literal: true

require "typhoeus"
require "json"
require "active_support/all"
require_relative "ac/version"
require_relative "ac/ac_object"
require_relative "ac/base"
require_relative "ac/json_patch"
require_relative "ac/database"

module Ac
  Typhoeus::Response.prepend JsonPatch

  class AcError < StandardError

    def self.from_response response
      case response.response.code
      when 401
        UnauthorizedError.new(response)
      when 404
        NotFoundError.new(response)
      when 422
        UnprocessableEntityError.new(response)
      when 429
        TooManyRequestsError.new(response)
      when 500..599
        ServerError.new(response)
      else
        AcError.new(response)
      end
    end

    attr_reader :response
    def initialize response
      @response = response
    end

    def to_s
      "#{self.class}: #{response.response.code} - #{response.values.present? ? response.inspect : response.response.body}"
    end
  end

  class BlockValidationError < AcError
  end

  class NotFoundError < AcError
  end

  class UnauthorizedError < AcError
  end

  class UnprocessableEntityError < AcError
  end

  class TooManyRequestsError < AcError
  end

  class ServerError < AcError
  end
end
