# frozen_string_literal: true
require "spec_helper"

RSpec.describe ResponseMessage do
  let(:fixture_path) { Pathname.new("./examples/response_message.json") }
  context "balance inquiry" do
    let(:json) { JSON.parse(fixture_path.read) }

    it "returns the same as the input" do
      expect(described_class.of_json(json).as_json).to eq json
    end

    it "can output a proper json for a balance inquiry" do
      message = described_class.of_json(json)
      expect(message.transaction_amount).to eq 0
      expect(message.system_trace_audit_number).to eq 110
      expect(message.local_transaction_at).to eq DateTime.new(2013, 11, 21, 10, 54, 14)
    end
  end
end
