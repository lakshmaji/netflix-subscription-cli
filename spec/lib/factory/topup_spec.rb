# frozen_string_literal: true

require 'rspec'
require_relative '../../../lib/factory/topup'

describe Factory do
  describe '#top_up' do
    it 'returns TopUpDeviceLimit4 instance for FOUR_DEVICE plan' do
      result = subject.top_up 'FOUR_DEVICE', 1
      expect(result).to be_an_instance_of(Config::TopUpDeviceLimit4)
    end

    it 'returns TopUpDeviceLimit10 instance for TEN_DEVICE plan' do
      result = subject.top_up('TEN_DEVICE', 2)
      expect(result).to be_a(Config::TopUpDeviceLimit10)
    end

    it 'returns TopUp instance for UNKNOWN plan' do
      result = subject.top_up 'UNKNOWN', 2
      expect(result).to be_an_instance_of(Config::TopUp)
    end

    it 'returns TopUp instance for no named plan' do
      result = Factory.top_up(nil, 3)
      expect(result).to be_an_instance_of(Config::TopUp)
    end
  end
end
