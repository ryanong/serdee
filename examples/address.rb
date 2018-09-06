# frozen_string_literal: true
class Address
  BYTES = {
    address: 22,
    city: 13,
    state: 3,
    country: 2
  }.freeze
  attr_accessor :address, :city, :state, :country
  def initialize(address:, city:, state:, country:)
    @address = address
    @city = city
    @state = state
    @country = country
  end

  def self.serialize(address)
    return if address.nil?
    BYTES.map do |field, bytes|
      address.send(field)[0...bytes].ljust(bytes, " ")
    end.join
  end

  def self.deserialize(string)
    return if string.nil?
    string = string.dup
    new(
      BYTES.transform_values { |bytes| string.slice!(0...bytes) }
    )
  end
end
