# frozen_string_literal: true

module Config
  # Helper mixin which provides utilities for topup plans
  module ToupHelper
    # Returns the total cost for given no of months
    def cost(no_of_months, cost)
      no_of_months * cost
    end
  end
end
