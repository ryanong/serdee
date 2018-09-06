require "json"
require "serdee/version"
require "serdee/attribute"
require "serdee/attributes"

module Serdee
  class << self
    attr_accessor :default_key_transform
  end
end
