# frozen_string_literal: true

require 'rspec'
require_relative '../../../lib/core/subscription'

describe Core::Subscription do
  subject { described_class.new }

  describe '#initialize' do
    it 'have empty subscribed_plans' do
      expect(subject.subscribed_plans).to have_attributes(length: 0)
    end

    it 'have empty top_ups' do
      expect(subject.top_ups).to have_attributes(length: 0)
    end

    it 'have no start_date' do
      expect(subject.start_date).to be_nil
    end
  end
end

describe Core::Subscription do
  subject { described_class.new }

  describe '#add_starts_on' do
    it 'sets subscription start_date' do
      today = Date.today
      subject.add_starts_on today
      expect(subject.start_date).to eql(today)
    end
  end
end

describe Core::Subscription do
  subject { described_class.new }

  describe '#add_subscribed_plan' do
    it 'adds music plan to subscribed_plans array' do
      music_plan = Config::Plan::MusicPlan.new
      subject.add_subscribed_plan music_plan
      expect(subject.subscribed_plans).to include(music_plan)
    end

    it 'adds video plan to subscribed_plans array' do
      video_plan = Config::Plan::VideoPlan.new
      subject.add_subscribed_plan video_plan
      expect(subject.subscribed_plans).to include(video_plan)
    end
  end
end
describe Core::Subscription do
  subject { described_class.new }
  describe '#category?' do
    it 'returns true when the plan category is already present' do
      music_plan = Config::Plan::MusicPlan.new
      subject.add_subscribed_plan music_plan
      result = subject.category? 'MUSIC'
      expect(result).to be(true)
    end

    it 'returns false when the plan category is not added' do
      Config::Plan::MusicPlan.new
      result = subject.category? 'MUSIC'
      expect(result).to be(false)
    end
  end
end
describe Core::Subscription do
  subject { described_class.new }
  describe '#add_top_up' do
    it 'adds device 4 limit for 2 months' do
      topup = Config::TopUpDeviceLimit4.new(2)
      subject.add_top_up topup
      expect(subject.top_ups).to include(topup)
    end

    it 'adds device 10 limit for 3 months' do
      topup = Config::TopUpDeviceLimit10.new(3)
      subject.add_top_up topup
      expect(subject.top_ups).to include(topup)
    end
  end

  describe '#top_up?' do
    it 'returns true when the top up is already present' do
      topup = Config::TopUpDeviceLimit4.new(2)
      subject.add_top_up topup
      expect(subject.top_up?).to be(true)
    end

    it 'returns false when the top up is not added' do
      Config::Plan::MusicPlan.new
      expect(subject.top_up?).to be(false)
    end
  end
end

describe Core::Subscription do
  subject { described_class.new }

  describe '#total_price' do
    it 'returns sum of plans, top up amounts' do
      music_plan = Config::Plan::MusicPlan.new
      music_plan.free
      subject.add_subscribed_plan music_plan

      video_plan = Config::Plan::VideoPlan.new
      video_plan.premium
      subject.add_subscribed_plan video_plan

      topup = Config::TopUpDeviceLimit4.new(2)
      subject.add_top_up topup

      expect(subject.total_price).to be(600)
    end
  end
end
