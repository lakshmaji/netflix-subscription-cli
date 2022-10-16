# frozen_string_literal: true

require 'rspec'
require_relative '../../../lib/factory/category'

describe Factory do
  describe '#category_plan' do
    it 'returns MusicPlan instance for MUSIC category' do
      result = Factory.category_plan 'MUSIC', 'FREE'
      expect(result).to be_an_instance_of(Config::Plan::MusicPlan)
    end

    it 'returns VideoPlan instance for VIDEO category' do
      result = Factory.category_plan 'VIDEO', 'PREMIUM'
      expect(result).to be_a(Config::Plan::VideoPlan)
    end

    it 'returns PodcastPlan instance for PODCAST category' do
      result = subject.category_plan 'PODCAST', 'PERSONAL'
      expect(result).to be_an_instance_of(Config::Plan::PodcastPlan)
    end

    it 'returns no instance for CONCERT category' do
      result = subject.category_plan 'CONCERT', 'PREMIUM'
      expect(result).to be_nil
    end
  end
  describe '#category_instance' do
    let(:mock_class) { Class.new { include Factory } }
    it 'returns MusicPlan instance for MUSIC category' do
      result = subject.category_instance 'MUSIC'
      expect(result).to be_an_instance_of(Config::Plan::MusicPlan)
    end

    it 'returns VideoPlan instance for VIDEO category' do
      result = subject.category_instance 'VIDEO'
      expect(result).to be_a(Config::Plan::VideoPlan)
    end

    it 'returns PodcastPlan instance for PODCAST category' do
      result = subject.category_instance 'PODCAST'
      expect(result).to be_an_instance_of(Config::Plan::PodcastPlan)
    end

    it 'returns no instance for CONCERT category' do
      result = subject.category_instance 'CONCERT'
      expect(result).to be_nil
    end
  end
end
