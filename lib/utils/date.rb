# frozen_string_literal: true

require 'date'

module Utils
  def valid_date?(str, format = '%d-%m-%Y')
    Date.strptime(str, format)
  rescue StandardError
    false
  end
  module_function :valid_date?
end
