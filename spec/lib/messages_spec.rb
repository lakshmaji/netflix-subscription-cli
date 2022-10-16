# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/messages'

describe Constants do
  describe '#renewal_remainder' do
    before(:all) do
      @mock_music_plan_personal = double('music personal plan')
      @mock_video_plan_premium = double('video premium plan')
      @mock_sub = double('subscription intance')
      @mock_category_music = double('music category')
      @mock_category_video = double('video category')
    end

    before(:each) do
      allow(@mock_category_music).to receive(:category).and_return('music')
      allow(@mock_category_video).to receive(:category).and_return('video')
      allow(@mock_video_plan_premium).to receive(:renewal_date).and_return('22-05-2022')
      allow(@mock_video_plan_premium).to receive(:class).and_return(@mock_category_music)
      allow(@mock_music_plan_personal).to receive(:renewal_date).and_return('26-07-2022')
      allow(@mock_music_plan_personal).to receive(:class).and_return(@mock_category_video)
      allow(@mock_sub).to receive(:start_date).and_return(Date.parse('08-12-2022'))
      allow(@mock_sub).to receive(:subscribed_plans).and_return(
        [
          @mock_music_plan_personal,
          @mock_video_plan_premium
        ]
      )

      subject.instance_variable_set(:@subscription, @mock_sub)
    end
    it 'appends available subscriptions' do
      result = String.new

      result << Constants.renewal_remainder(@mock_sub)
      expect(result).to eql(
        "RENEWAL_REMINDER VIDEO 26-07-2022\nRENEWAL_REMINDER MUSIC 22-05-2022\n"
      )
    end
  end

  describe '#renewal_amount' do
    it 'returns amount with message' do
      result = String.new

      result << Constants.renewal_amount(100)
      expect(result).to eql(
        "RENEWAL_AMOUNT 100\n"
      )
    end
  end
end
