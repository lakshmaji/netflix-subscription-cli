# frozen_string_literal: true

require_relative 'subscription'
require_relative '../messages'

module Core
  # The class communicates with subscription class
  # This manupulates over subscription instance, to compute subscription renewals
  class Manage
    attr_accessor :subscription

    def initialize
      @subscription = Core::Subscription.new
    end

    # 'FOUR_DEVICE', 2
    def add_topup(name, months)
      return Constants::ADD_TOPUP_FAILED_INVALID_DATE if subscription.start_date == Constants::INVALID_DATE

      return Constants::DUPLICATE_TOPUP if subscription.top_up?

      subscription.add_top_up(Factory.top_up(name, months))
    end

    # 'music', 'premium'
    def add_subscription(category, plan)
      return Constants::ADD_SUBSCRIPTION_FAILED_INVALID_DATE if subscription.start_date == Constants::INVALID_DATE

      return Constants::ADD_SUBSCRIPTION_FAILED_DUPLICATE_CATEGORY if subscription.category?(category)

      subscription.add_subscribed_plan(Factory.category_plan(category, plan))
    end

    def add_date(input_date)
      return subscription.add_starts_on(Constants::INVALID_DATE) unless Utils.valid_date? input_date

      subscription.add_starts_on(Utils.valid_date?(input_date))
    end

    def print_info(result)
      return Constants::SUBSCRIPTIONS_NOT_FOUND if subscription.subscribed_plans.empty?

      result << Constants.renewal_remainder(subscription)
      result << Constants.renewal_amount(subscription.total_price)
    end
  end
end
