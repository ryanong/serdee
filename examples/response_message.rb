# frozen_string_literal: true
require_relative "./unified_message"
require_relative "./response_code"
class ResponseMessage
  include Serdee::Attributes
  set_key_transform :camel_lower

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
