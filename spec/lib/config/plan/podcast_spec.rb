# frozen_string_literal: true

require 'rspec'

require_relative '../../../../lib/config/plan/podcast'
require_relative '../../../../lib/config/plan/plan'

describe Config::Plan::PodcastPlan do
  subject(:membership) { described_class.new }

  describe '#premium' do
    it 'sets amount to 300' do
      membership.premium
      expect(membership.amount).to eql(300)
    end

    it 'sets time to 2 months' do
      membership.premium
      expect(membership.time).to eql(2)
    end
  end
end
describe Config::Plan::PodcastPlan do
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
describe Config::Plan::PodcastPlan do
  subject(:membership) { described_class.new }

  describe '#category' do
    it 'has plan category name' do
      expect(membership.class.category).to eql('podcast')
    end
  end

  it 'should be a subscription class of BasePlan' do
    expect(described_class.superclass).to be Config::Plan::BasePlan
  end
end
