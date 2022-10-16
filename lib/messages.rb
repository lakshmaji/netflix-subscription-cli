# frozen_string_literal: true

# All string and formatting related constants are defined in this class
class Constants
  INVALID_DATE = 'INVALID_DATE'
  START_SUBSCRIPTION = 'START_SUBSCRIPTION'
  ADD_SUBSCRIPTION = 'ADD_SUBSCRIPTION'
  ADD_TOPUP = 'ADD_TOPUP'
  PRINT_RENEWAL_DETAILS = 'PRINT_RENEWAL_DETAILS'
  SUBSCRIPTIONS_NOT_FOUND = 'SUBSCRIPTIONS_NOT_FOUND'
  ADD_TOPUP_FAILED_INVALID_DATE = 'ADD_TOPUP_FAILED INVALID_DATE'
  DUPLICATE_TOPUP = 'ADD_TOPUP_FAILED DUPLICATE_TOPUP'
  ADD_SUBSCRIPTION_FAILED_INVALID_DATE = 'ADD_SUBSCRIPTION_FAILED INVALID_DATE'
  ADD_SUBSCRIPTION_FAILED_DUPLICATE_CATEGORY = 'ADD_SUBSCRIPTION_FAILED DUPLICATE_CATEGORY'

  def self.renewal_remainder(sub)
    result = String.new ''
    sub.subscribed_plans.each do |po|
      result << "RENEWAL_REMINDER #{po.class.category.upcase} #{po.renewal_date(sub.start_date)}\n"
    end
    result
  end

  def self.renewal_amount(total_price)
    "RENEWAL_AMOUNT #{total_price}\n"
  end
end
