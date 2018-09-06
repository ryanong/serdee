require "json"
require "serder/version"
require "serder/attribute"
require "serder/attributes"

module Serdee
  class << self
    attr_accessor :default_key_transform
  end
end
