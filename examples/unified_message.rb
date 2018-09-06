# frozen_string_literal: true
require_relative "./address"
require_relative "./response_code"

class UnifiedMessage
  include Serdee::Attributes
  serialize_key { |key| key.camelize(:lower) }
  deserialize_key { |key| key.underscore }

  PROCESSING_CODES = {
    balance_inquiry: "315400",
    redemption: "615400"
  }.freeze

  nested :header do
    attribute :signature, default: "BHNUMS"
    nested :details do
      attribute :product_category_code, default: "01"
      attribute :spec_version, default: "43"
      attribute :status_code
    end
  end

  nested :transaction do
    attribute :local_transaction_at do
      insert do |time, hash|
        if time
          hash[:local_transaction_time] = time.strftime("%H%M%S")
          hash[:local_transaction_date] = time.strftime("%y%m%d")
        end
      end

      extract do |data|
        if data[:local_transaction_date] && data[:local_transaction_time]
          time_string = "#{data[:local_transaction_date]}-#{data[:local_transaction_time]}"
          DateTime.strptime(time_string, "%y%m%d-%H%M%S")
        end
      end
    end
    attribute :retrieval_reference_number do
      serialize { |int| format("%012d", int) }
      deserialize { |string| string&.to_i }
    end
    attribute :system_trace_audit_number do
      serialize { |int| format("%06d", int) }
      deserialize { |string| string&.to_i }
    end
    attribute :transaction_amount do
      serialize { |int| format("%012d", int) }
      deserialize { |string| string&.to_i }
    end
    attribute :transmission_date_time do
      serialize { |time| time&.strftime("%y%m%d%H%M%S") }
      deserialize { |time_string| DateTime.strptime(time_string, "%y%m%d%H%M%S") if time_string }
    end
    attribute :merchant_identifier do
      serialize { |id| id&.ljust(15, " ") }
      deserialize { |id| id&.strip }
    end
    attribute :action, as: :processing_code do
      serialize { |action| PROCESSING_CODES.fetch(action) }
      deserialize { |code| PROCESSING_CODES.key(code) }
    end
    attribute :merchant_location, serializer: Address

    attribute :authidentification_response
    attribute :acquiring_institution_identifier
    attribute :merchant_category_code
    attribute :merchant_terminal_id
    attribute :point_of_service_entry_mode
    attribute :primary_account_number
    attribute :response_code
    attribute :transaction_currency_code

    nested :additional_txn_fields do
      attribute :balance_amount do
        serialize do |int|
          return if int.nil?
          (int >= 0 ? "C" : "D") + int.abs.to_s.rjust(12, "0")
        end
        deserialize do |string|
          return if string.nil?
          int = string[1..-1].to_i
          return -int if string[0] == "D"
          int
        end
      end
      attribute :correlated_transaction_unique_id
      attribute :product_id
      attribute :transaction_unique_id
      attribute :redemption_pin do
        serialize { |pin| pin&.ljust(16, " ") }
        deserialize { |pin| pin&.strip }
      end
    end
  end
end
