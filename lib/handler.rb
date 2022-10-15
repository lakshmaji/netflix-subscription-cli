# frozen_string_literal: true

require_relative 'core/subscription'
require_relative 'utils/date'
require_relative 'factory/category'
require_relative 'factory/topup'

# This will convert each line in a file into a meaningful command and optional data.
# perform actions for each command given.
# prints the final result to STDOUT.
class Handler
  attr_accessor :sub

  def initialize
    @sub = Core::Subscription.new
  end

  def run(cmds)
    output = []
    cmds.each do |line|
      result = process_command(line)
      output << result if result.instance_of? String
    end
    output
  end

  private

  def process_command(line)
    case line[:cmd]
    when 'START_SUBSCRIPTION'
      add_date(line[:date])
    when 'ADD_SUBSCRIPTION'
      add_subscription(line[:category], line[:plan])
    when 'ADD_TOPUP'
      add_topup(line[:name], line[:months])
    when 'PRINT_RENEWAL_DETAILS'
      print_info
    end
  end

  def print_info
    return 'SUBSCRIPTIONS_NOT_FOUND' if sub.subscribed_plans.empty?

    result = String.new ''
    append_result(result)
    result << "RENEWAL_AMOUNT #{sub.total_price}\n"
  end

  def append_result(result)
    sub.subscribed_plans.each do |po|
      result << "RENEWAL_REMINDER #{po.class.category.upcase} #{po.renewal_date(sub.start_date)}\n"
    end
  end

  # 'FOUR_DEVICE', 2
  def add_topup(name, months)
    return 'ADD_TOPUP_FAILED INVALID_DATE' if sub.start_date == 'INVALID_DATE'

    return 'ADD_TOPUP_FAILED DUPLICATE_TOPUP' if sub.top_up?

    plan = Factory.top_up(name, months)
    sub.add_top_up(plan)
  end

  # 'music', 'premium'
  def add_subscription(category, plan)
    plan_category = Factory.category(category)

    # call plan on the specific category
    plan_category.method(plan.downcase.to_sym).call

    return 'ADD_SUBSCRIPTION_FAILED INVALID_DATE' if sub.start_date == 'INVALID_DATE'

    return 'ADD_SUBSCRIPTION_FAILED DUPLICATE_CATEGORY' if sub.category?(category)

    sub.add_subscribed_plan(plan_category)
  end

  # '05-02-2022'
  def add_date(input_date)
    valid_date = Utils.valid_date? input_date
    unless valid_date
      sub.add_starts_on('INVALID_DATE')
      return 'INVALID_DATE'
    end

    sub.add_starts_on(valid_date)
  end
end
