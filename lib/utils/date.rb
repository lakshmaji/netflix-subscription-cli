# frozen_string_literal: true

require 'date'

# Utils module contains valid_date?
# valid_date?
#     Validate whether given date is valid or not in specified format
#     Returns date instance if the given input is valid otherwise it returns false.
module Utils
  def valid_date?(str, format = '%d-%m-%Y')
    Date.strptime(str, format)
  rescue StandardError
    false
  end
  module_function :valid_date?
end
