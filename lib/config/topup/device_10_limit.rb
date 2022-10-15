# frozen_string_literal: true

require_relative 'topup'

module Config
  # This class maintains cost price when purchasing DEVICE_LIMIT_10 plan
  class TopUpDeviceLimit10 < TopUp
    def initialize(no_of_months)
      super(no_of_months)
      @cost = 100
    end
  end
end
