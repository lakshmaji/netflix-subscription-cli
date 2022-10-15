# frozen_string_literal: true

require 'rspec'

require_relative '../../../../lib/config/plan/music'
require_relative '../../../../lib/config/plan/plan'

describe Config::Plan::MusicPlan do
  subject(:membership) { described_class.new }

  describe '#premium' do
    it 'sets amount to 250' do
      membership.premium
      expect(membership.amount).to eql(250)
    end

    it 'sets time to 3 months' do
      membership.premium
      expect(membership.time).to eql(3)
    end
  end
end
describe Config::Plan::MusicPlan do
  subject(:membership) { described_class.new }

  describe '#personal' do
    it 'sets amount to 100' do
      membership.personal
      expect(membership.amount).to eql(100)
    end

    it 'sets time to 1 month' do
      membership.personal
      expect(membership.time).to eql(1)
    end
  end
end
describe Config::Plan::MusicPlan do
  subject(:membership) { described_class.new }

  describe '#category' do
    it 'has plan category name' do
      expect(membership.class.category).to eql('music')
    end
  end

  it 'should be a sub class of BasePlan' do
    expect(described_class.superclass).to be Config::Plan::BasePlan
  end
end
