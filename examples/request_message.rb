# frozen_string_literal: true
require_relative "./unified_message"

class RequestMessage
  include Serdee::Attributes
  set_key_transform :camel_lower

  nested :request, UnifiedMessage
end
