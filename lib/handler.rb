# frozen_string_literal: true

require_relative 'utils/date'
require_relative 'factory/category'
require_relative 'factory/topup'
require_relative 'core/manage'

# This will convert each line in a file into a meaningful command and optional data.
# perform actions for each command given.
# prints the final result to STDOUT.
class Handler
  attr_accessor :manager

  def initialize
    @manager = Core::Manage.new
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
    when Constants::START_SUBSCRIPTION
      manager.add_date(line[:date])
    when Constants::ADD_SUBSCRIPTION
      manager.add_subscription(line[:category], line[:plan])
    when Constants::ADD_TOPUP
      manager.add_topup(line[:name], line[:months])
    when Constants::PRINT_RENEWAL_DETAILS
      manager.print_info
    end
  end
end
