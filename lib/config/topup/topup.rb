# frozen_string_literal: true

require_relative 'helper'

module Config
  # This is the base class representing the default topup members.
  # This holds the default topup cost.
  #
  # Given a specified no of months, the `total_cost` will compute the total payable amount.
  class TopUp
    include ToupHelper

    attr_reader :no_of_months

    def initialize(no_of_months)
      @cost = 0
      @no_of_months = no_of_months
    end

    def total_cost
      cost(@no_of_months, @cost)
    end
  end
end
