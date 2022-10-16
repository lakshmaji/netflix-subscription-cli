# frozen_string_literal: true

module Core
  # Parses provided line into system understandble format.
  class Commands
    attr_accessor :cmds

    def initialize
      self.cmds = []
    end

    def add(line)
      cmds << parse(line)
    end

    private

    def parse(line)
      cmd, *options = line.split
      case cmd
      when Constants::START_SUBSCRIPTION then { cmd: cmd, date: options.first }
      when Constants::ADD_SUBSCRIPTION then { cmd: cmd, category: options.first, plan: options.last }
      when Constants::ADD_TOPUP then { cmd: cmd, name: options.first, months: options.last.to_i }
      when Constants::PRINT_RENEWAL_DETAILS then { cmd: cmd }
      else
        raise "Error: invalid command specified (#{line})"
      end
    end
  end
end
