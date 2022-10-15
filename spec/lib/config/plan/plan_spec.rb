# frozen_string_literal: true

require 'rspec'
require 'date'
require_relative '../../../../lib/config/plan/plan'

describe Config::Plan::BasePlan do
  subject(:default_subscription) { described_class.new }
  describe '#free' do
    it 'sets amount to 0 for trial' do
      default_subscription.free
      expect(default_subscription.amount).to eql(0)
    end

    it 'sets time to 1 month' do
      default_subscription.free
      expect(default_subscription.time).to eql(1)
    end
  end
end

describe Config::Plan::BasePlan do
  subject(:default_subscription) { described_class.new }

  describe '#personal' do
    it 'raises' do
      expect { default_subscription.personal }.to raise_error(RuntimeError)
    end
  end

  describe '#personal' do
    it 'raises' do
      expect { default_subscription.personal }.to raise_error.with_message('Implement personal method')
    end
  end
end

describe Config::Plan::BasePlan do
  subject(:default_subscription) { described_class.new }

  describe '#premium' do
    it 'raises' do
      expect { default_subscription.premium }.to raise_error(RuntimeError)
    end
  end

  describe '#premium' do
    it 'raises' do
      expect { default_subscription.premium }.to raise_error.with_message('Implement premuim method')
    end
  end
end

describe Config::Plan::BasePlan do
  subject(:default_subscription) { described_class.new }

  describe '#renewal_date' do
    it 'returns renewal date for free plan' do
      default_subscription.free
      today = Date.today
      renewal_remainder_date = default_subscription.renewal_date(today)
      expected = today.next_month.prev_day 10
      expect(renewal_remainder_date).to eql(expected.strftime('%d-%m-%Y'))
    end
  end
end
