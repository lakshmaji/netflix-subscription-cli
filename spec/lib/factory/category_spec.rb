# frozen_string_literal: true

require 'rspec'
require_relative '../../../lib/factory/category'

describe Factory do
  describe '#category' do
    it 'returns MusicPlan instance for MUSIC category' do
      result = Factory.category 'MUSIC'
      expect(result).to be_an_instance_of(Config::Plan::MusicPlan)
    end

    it 'returns VideoPlan instance for VIDEO category' do
      result = Factory.category 'VIDEO'
      expect(result).to be_a(Config::Plan::VideoPlan)
    end

    it 'returns PodcastPlan instance for PODCAST category' do
      result = subject.category 'PODCAST'
      expect(result).to be_an_instance_of(Config::Plan::PodcastPlan)
    end

    it 'returns no instance for CONCERT category' do
      result = subject.category 'CONCERT'
      expect(result).to be_nil
    end
  end
end
