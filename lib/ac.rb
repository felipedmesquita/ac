# frozen_string_literal: true

require "typhoeus"
require "json"
require_relative "ac/version"
require_relative "ac/base"
require_relative "ac/json_patch"
require_relative "ac/database"

module Ac
  Typhoeus::Response.prepend JsonPatch
end
