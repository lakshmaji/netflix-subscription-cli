# frozen_string_literal: true

require_relative '../config/topup/topup'
require_relative '../config/topup/device_four'
require_relative '../config/topup/device_ten'

# Factory method, which will return instance for topup device limit
module Factory
  def top_up(name, months)
    case name
    when 'FOUR_DEVICE'
      Config::TopUpDeviceLimit4.new months
    when 'TEN_DEVICE'
      Config::TopUpDeviceLimit10.new months
    else
      Config::TopUp.new months
    end
  end
  module_function :top_up
end
