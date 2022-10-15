# frozen_string_literal: true

require 'rspec'
require_relative '../../../../lib/config/topup/helper'

# This is a helper class to test out the helper mixin.
class Mock
  include Config::ToupHelper

  def compute(months, price)
    cost(months, price)
  end
end
describe Config::ToupHelper do
  describe '#cost' do
    it 'returns total' do
      result = Mock.new.compute(13, 2)
      expect(result).to eql(26)
    end
  end
end
