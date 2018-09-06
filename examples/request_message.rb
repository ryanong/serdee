# frozen_string_literal: true
require_relative "./unified_message"

class RequestMessage
  include Serdee::Attributes
  serialize_key { |key| key.camelize(:lower) }
  deserialize_key { |key| key.underscore }

  nested :request, UnifiedMessage
end
