# frozen_string_literal: true

require 'rspec'
require_relative '../../../../lib/config/topup/topup'

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
