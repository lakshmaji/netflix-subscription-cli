# frozen_string_literal: true

require 'rspec'
require_relative '../../../../lib/config/topup/topup'
require_relative '../../../../lib/config/topup/helper'

describe Config::TopUp do
  subject { described_class.new(2) }
  describe '#initialize' do
    it 'set no_of_months' do
      expect(subject.no_of_months).to eql(2)
    end
  end

  describe '#total_cost' do
    it 'return total cost for default topup is 0' do
      expect(subject.total_cost).to eql(0)
    end
  end
end

describe Config::TopUpDeviceLimit4 do
  context 'inherit' do
    it 'should be a sub class of TopUp' do
      expect(Config::TopUpDeviceLimit4.superclass).to be Config::TopUp
    end
  end

  context 'methods' do
    subject(:topup) { described_class.new(2) }
    describe '#initialize' do
      it 'set no_of_months' do
        expect(topup.no_of_months).to eql(2)
      end
    end

    describe '#total_cost' do
      it 'return total cost for device_limit_4 topup is 100' do
        expect(topup.total_cost).to eql(100)
      end
    end
  end
end

describe Config::TopUpDeviceLimit10 do
  context 'inherit' do
    it 'should be a sub class of TopUp' do
      expect(Config::TopUpDeviceLimit10.superclass).to be Config::TopUp
    end
  end

  context 'methods' do
    subject(:topup) { described_class.new(2) }
    describe '#initialize' do
      it 'set no_of_months' do
        expect(topup.no_of_months).to eql(2)
      end
    end

    describe '#total_cost' do
      it 'return total cost for device_limit_10 topup is 100' do
        expect(topup.total_cost).to eql(200)
      end
    end
  end
end

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
