# frozen_string_literal: true

require_relative 'lib/core/commands'
require_relative 'lib/handler'

$LOAD_PATH.unshift File.join(__dir__, 'lib')

# Read input
def main
  fileinput = ARGV[1]
  file = File.open(fileinput)
  input = Core::Commands.new
  file.readlines.each do |line|
    input.add(line)
  end
  compute_subscription(input.cmds)
end


# handle business logic
def compute_subscription(cmds)
  handler = Handler.new
  result = handler.run(cmds)
  puts result
end
