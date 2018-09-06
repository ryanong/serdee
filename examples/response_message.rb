# frozen_string_literal: true
require_relative "./unified_message"
require_relative "./response_code"
class ResponseMessage
  include Serdee::Attributes
  serialize_key { |key| key.camelize(:lower) }
  deserialize_key { |key| key.underscore }

  attr_accessor :request_id

  nested :response, UnifiedMessage

  def parsed_message?
    status_code == "00" if status_code
  end

  def status
    return unless response_code
    @status ||= ResponseCode.find(response_code)
  end

  def approved?
    status&.approved?
  end
end
