# frozen_string_literal: true

require_relative 'topup'

module Config
  # This class maintains cost price when purchasing DEVICE_LIMIT_4 plan
  class TopUpDeviceLimit4 < TopUp
    def initialize(no_of_months)
      super(no_of_months)
      @cost = 50
    end
  end
end
