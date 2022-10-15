# frozen_string_literal: true

module Core
  # This is holds all the subscription related details like the
  #   purchase subscription plan categories
  #   topup plans to increase the device limit
  #   the subscription start date.
  #
  # The `total_price` method will compute the final payable amount for.
  # subscribed plans and topup, if applicable.
  class Subscription
    attr_accessor :start_date, :subscribed_plans, :top_ups

    def initialize
      @subscribed_plans = []
      @top_ups = []
    end

    def add_starts_on(date)
      self.start_date = date
    end

    def add_subscribed_plan(plan)
      subscribed_plans << plan
    end

    def category?(category)
      subscribed_plans.any? { |po| po.class.category.upcase == category.upcase }
    end

    def total_price
      plans_total = subscribed_plans.sum(&:amount)
      topup_total = top_ups.sum(&:total_cost)
      plans_total + topup_total
    end

    def top_up?
      !top_ups.empty?
    end

    def add_top_up(plan)
      top_ups << plan
    end
  end
end
