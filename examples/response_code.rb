# frozen_string_literal: true
class ResponseCode
  attr_reader :code, :type, :message
  def initialize(code:, type:, message:)
    @code = code
    @type = type
    @message = message
  end

  def approved?
    type == :approved
  end

  def soft_declined?
    type == :soft_declined
  end

  def hard_declined?
    type == :hard_declined
  end

  def self.find(code)
    response = CODES.fetch(code)
    new(
      code: code,
      type: response[0],
      message: response[1]
    )
  end

  CODES = {
    "00" => [:approved, "Approved – balance available"],
    "01" => [:approved, "Approved – balance unavailable"],
    "03" => [:approved, "Approved – balance unavailable on external account number"],
    "74" => [:soft_declined, "Unable to route / System Error"],
    "15" => [:soft_declined, "Time Out occurred- Auth Server not available /responding"],
    "02" => [:hard_declined, "Refer to card issuer"],
    "04" => [:hard_declined, "Already Redeemed"],
    "05" => [:hard_declined, "Error account problem"],
    "06" => [:hard_declined, "Invalid expiration date"],
    "07" => [:hard_declined, "Unable to process"],
    "08" => [:hard_declined, "Card not found"],
    "12" => [:hard_declined, "Invalid transaction"],
    "13" => [:hard_declined, "Invalid amount"],
    "14" => [:hard_declined, "Invalid Product"],
    "16" => [:hard_declined, "Invalid status change"],
    "17" => [:hard_declined, "Invalid merchant"],
    "18" => [:hard_declined, "Invalid Phone Number"],
    "20" => [:hard_declined, "Invalid Pin"],
    "21" => [:hard_declined, "Card already active"],
    "22" => [:hard_declined, "Card Already Associated"],
    "30" => [:hard_declined, "Bad track2 – format error"],
    "33" => [:hard_declined, "Expired card"],
    "34" => [:hard_declined, "Already reversed"],
    "35" => [:hard_declined, "Already voided"],
    "36" => [:hard_declined, "Restricted card"],
    "37" => [:hard_declined, "Restricted External Account"],
    "38" => [:hard_declined, "Restricted Merchant"],
    "41" => [:hard_declined, "Lost card"],
    "42" => [:hard_declined, "Lost External Account"],
    "43" => [:hard_declined, "Stolen card"],
    "44" => [:hard_declined, "Stolen External Account"],
    "51" => [:hard_declined, "Insufficient funds"],
    "54" => [:hard_declined, "Expired External Account"],
    "55" => [:hard_declined, "Max recharge reached"],
    "56" => [:hard_declined, "Advance less amount / enter lesser amount"],
    "58" => [:hard_declined, "Request not permitted by merchant location"],
    "59" => [:hard_declined, "Request not permitted by processor"],
    "61" => [:hard_declined, "Exceeds withdrawal amt / over limit"],
    "62" => [:hard_declined, "Exceeds financial limit"],
    "65" => [:hard_declined, "Exceeds withdrawal frequency limit"],
    "66" => [:hard_declined, "Exceeds transaction count limit"],
    "69" => [:hard_declined, "Format error –bad data"],
    "71" => [:hard_declined, "Invalid External Account number"],
    "94" => [:hard_declined, "Duplicate transaction"],
    "95" => [:hard_declined, "Cannot Reverse the Original Transaction"],
    "99" => [:hard_declined, "General decline"],
  }.freeze
end
