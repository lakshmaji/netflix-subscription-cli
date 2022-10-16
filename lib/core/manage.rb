# frozen_string_literal: true

require_relative 'subscription'
require_relative '../../lib/messages'

module Core
  # The class communicates with subscription class
  # This manupulates over subscription instance, to compute subscription renewals
  class Manage
    attr_accessor :sub

    def initialize
      @sub = Core::Subscription.new
    end

    # 'FOUR_DEVICE', 2
    def add_topup(name, months)
      return Constants::ADD_TOPUP_FAILED_INVALID_DATE if sub.start_date == Constants::INVALID_DATE

      return Constants::DUPLICATE_TOPUP if sub.top_up?

      plan = Factory.top_up(name, months)
      sub.add_top_up(plan)
    end

    # 'music', 'premium'
    def add_subscription(category, plan)
      plan_category = Factory.category(category)

      # call plan on the specific category
      plan_category.method(plan.downcase.to_sym).call

      return Constants::ADD_SUBSCRIPTION_FAILED_INVALID_DATE if sub.start_date == Constants::INVALID_DATE

      return Constants::ADD_SUBSCRIPTION_FAILED_DUPLICATE_CATEGORY if sub.category?(category)

      sub.add_subscribed_plan(plan_category)
    end

    # '05-02-2022'
    def add_date(input_date)
      valid_date = Utils.valid_date? input_date
      unless valid_date
        sub.add_starts_on(Constants::INVALID_DATE)
        return Constants::INVALID_DATE
      end

      sub.add_starts_on(valid_date)
    end

    def print_info
      return Constants::SUBSCRIPTIONS_NOT_FOUND if sub.subscribed_plans.empty?

      result = String.new ''
      result << Constants.renewal_remainder(sub)
      result << Constants.renewal_amount(sub.total_price)
    end
  end
end
