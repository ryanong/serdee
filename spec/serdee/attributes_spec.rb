RSpec.describe Serdee::Attributes do
  class OptionalFields
    include Serdee::Attributes

    attribute :optional_field, optional: true
    attribute :default_field, default: "default"
  end

  class RequireFields
    include Serdee::Attributes

    attribute :required_field
    attribute :optional_field, optional: true
    attribute :default_field, default: true
  end

  it "raises an error when no setting default" do
    expect {
      RequireFields.new
    }.to raise_error(ArgumentError)
  end

  it "does not raise an error when only default or optional fields" do
    message = OptionalFields.new
    expect(message.default_field).to eq "default"
  end
end
