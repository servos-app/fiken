require "json"
require "net/http"
require "openssl"
require "securerandom"
require "uri"

require_relative "fiken/version"
require_relative "fiken/errors"
require_relative "fiken/response"
require_relative "fiken/connection"
require_relative "fiken/multipart"
require_relative "fiken/token"
require_relative "fiken/authorization"
require_relative "fiken/resource"
Dir[File.join(__dir__, "fiken/resources/*.rb")].each { |file| require file }
require_relative "fiken/company"
require_relative "fiken/client"

# Ruby client for the Fiken API v2, https://api.fiken.no/api/v2/docs
module Fiken
end
