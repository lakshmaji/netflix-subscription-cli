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
      when 'START_SUBSCRIPTION' 
        return { :cmd => cmd, date: options.first }
      when 'ADD_SUBSCRIPTION' 
        return { :cmd => cmd, category: options.first, plan: options.last }
      when 'ADD_TOPUP' 
        return { :cmd => cmd, name: options.first, months: options.last.to_i }
      when 'PRINT_RENEWAL_DETAILS' 
        return { :cmd => cmd }
      else
        raise "Error: invalid command specified (#{line})"
      end
    end
  end
end
