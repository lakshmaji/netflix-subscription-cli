# frozen_string_literal: true

require 'rspec'
require_relative '../../../../lib/config/topup/device_ten'

describe Config::TopUpDeviceLimit10 do
  context 'inherit' do
    it 'should be a subscription class of TopUp' do
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
