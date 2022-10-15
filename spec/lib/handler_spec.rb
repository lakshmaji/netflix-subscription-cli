# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/handler'
require_relative '../../lib/core/subscription'
require_relative '../../lib/config/topup/topup'
require_relative '../../lib/config/topup/device_4_limit'
require_relative '../../lib/config/topup/device_10_limit'
require_relative '../../lib/factory/topup'
require_relative '../../lib/factory/category'
require_relative '../../lib/utils/date'

describe Handler do
  describe '#initialize' do
    it 'has subscription class instance' do
      expect(subject.sub).to be_a Core::Subscription
    end
  end
end

describe Handler do
  describe '#run' do
    it 'has subscription class instance' do
      allow_any_instance_of(Handler).to receive(:process_command) do
        'COMMAND OUTPUT'
      end

      command = 'START_SUBSCRIPTION'
      option = '05-02-2022'

      result = subject.run([{ cmd: command, date: option }])
      expect(result).to match_array(['COMMAND OUTPUT'])
    end

    it 'should not return date instance' do
      allow_any_instance_of(Handler).to receive(:process_command) do
        Date.today
      end
      result = subject.run([{ cmd: 'PRINT_RENEWAL_DETAILS' }])
      expect(result).to match_array([])
    end
  end
end

describe Handler do
  describe '#process_command' do
    describe 'start date' do
      it 'returns command operation result' do
        allow_any_instance_of(Handler).to receive(:add_date) do |_ar|
          '05-02-2022'
        end

        result = subject.send(:process_command, cmd: 'START_SUBSCRIPTION', date: '05-02-2022')
        expect(result).to eql('05-02-2022')
      end
    end
  end
end

describe Handler do
  describe '#process_command' do
    describe 'add subscription' do
      it 'returns command operation result' do
        allow_any_instance_of(Handler).to receive(:add_subscription) do |_ar|
          'SUBSCRIPTION ADDED'
        end

        result = subject.send(:process_command, cmd: 'ADD_SUBSCRIPTION', category: 'MUSIC',
                                                plan: 'PERSONAL')
        expect(result).to eql('SUBSCRIPTION ADDED')
      end
    end
  end
end

describe Handler do
  describe '#process_command' do
    describe 'unknown command' do
      it 'returns nothing' do
        result = subject.send(:process_command, cmd: 'ADD_USER')
        expect(result).to be_nil
      end
    end
  end
end

describe Handler do
  describe '#process_command' do
    describe 'add topup' do
      it 'returns command operation result' do
        allow_any_instance_of(Handler).to receive(:add_topup) do |_ar|
          'TOP UP ADDED'
        end

        result = subject.send(:process_command, cmd: 'ADD_TOPUP', name: 'DEVICE_4', months: 2)
        expect(result).to eql('TOP UP ADDED')
      end
    end
  end
end

describe Handler do
  describe '#process_command' do
    it 'returns string' do
      allow_any_instance_of(Handler).to receive(:print_info) do |_ar|
        'sample putput string'
      end

      result = subject.send(:process_command, cmd: 'PRINT_RENEWAL_DETAILS')
      expect(result).to eql('sample putput string')
    end
  end
end

describe Handler do
  describe '#print_info' do
    context 'when no subscriptions are added' do
      it 'returns subscription not found' do
        mock_sub = double('subscription instance')

        subject.instance_variable_set(:@sub, mock_sub)
        allow(mock_sub).to receive(:subscribed_plans).and_return([])

        result = subject.send(:print_info)
        expect(result).to eql('SUBSCRIPTIONS_NOT_FOUND')
      end
    end

    context 'when subscriptions are added' do
      it 'returns renewal details' do
        mock_sub = double('subscription instance')

        subject.instance_variable_set(:@sub, mock_sub)
        allow(mock_sub).to receive(:subscribed_plans).and_return(['plan 1'])
        allow(mock_sub).to receive(:total_price) { 600 }
        allow_any_instance_of(Handler).to receive(:append_result) do |_instance, input|
          input << "renewal date for subscriptions.\n"
        end
        result = subject.send(:print_info)
        expect(result).to eql("renewal date for subscriptions.\nRENEWAL_AMOUNT 600\n")
      end
    end
  end
end

describe Handler do
  describe '#append_result' do
    before(:all) do
      @mock_music_plan_personal = double('music personal plan')
      @mock_video_plan_premium = double('video premium plan')
      @mock_sub = double('sub intance')
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

      subject.instance_variable_set(:@sub, @mock_sub)
    end
    it 'appends available subscriptions' do
      output = String.new

      subject.send(:append_result, output)
      expect(output).to eql(
        "RENEWAL_REMINDER VIDEO 26-07-2022\nRENEWAL_REMINDER MUSIC 22-05-2022\n"
      )
    end
  end
end

describe Handler do
  describe '#add_topup' do
    it 'fails with invalid date' do
      mock_sub = double('sub intance')
      mock_topup_instance = double('topup factory')

      subject.instance_variable_set(:@sub, mock_sub)
      allow_any_instance_of(Factory).to receive(:top_up) { mock_topup_instance }
      allow(mock_sub).to receive(:start_date).and_return('INVALID_DATE')

      result = subject.send(:add_topup, 'FOUR_DEVICE', 2)
      expect(result).to eql 'ADD_TOPUP_FAILED INVALID_DATE'
    end

    it 'fails with duplicate topup' do
      mock_sub = double('sub intance')

      subject.instance_variable_set(:@sub, mock_sub)
      allow_any_instance_of(Factory).to receive(:top_up) { mock_topup_instance }
      allow(mock_sub).to receive(:start_date).and_return(Date.parse('05-02-2022'))
      allow(mock_sub).to receive(:top_up?).and_return(true)

      result = subject.send(:add_topup, 'FOUR_DEVICE', 2)
      expect(result).to eql 'ADD_TOPUP_FAILED DUPLICATE_TOPUP'
    end

    it 'adds top up to sub instance' do
      mock_plan = double('plan factory')
      mock_sub = double('sub intance')
      mock_topup_instance = double('topup factory')

      subject.instance_variable_set(:@sub, mock_sub)
      allow_any_instance_of(Factory).to receive(:top_up) { mock_topup_instance }
      allow(mock_plan).to receive(:new).and_return('TOUP instance')
      allow(mock_sub).to receive(:add_top_up).and_return('Added topup plan')
      allow(mock_sub).to receive(:start_date).and_return(Date.parse('05-02-2022'))
      allow(mock_sub).to receive(:top_up?).and_return(false)

      result = subject.send(:add_topup, 'FOUR_DEVICE', 2)
      expect(result).to eql 'Added topup plan'
    end
  end
end

describe Handler do
  describe '#add_subscription' do
    it 'returns invalid date' do
      mock_sub = double('sub intance')

      mock_plan_instance = double('plan factory')
      allow_any_instance_of(Factory).to receive(:category) { mock_plan_instance }
      allow(mock_plan_instance).to receive(:free).and_return('ADD FREE PLAN')

      subject.instance_variable_set(:@sub, mock_sub)
      allow(mock_sub).to receive(:start_date).and_return('INVALID_DATE')

      result = subject.send(:add_subscription, 'MUSIC', 'free')
      expect(result).to eql 'ADD_SUBSCRIPTION_FAILED INVALID_DATE'
    end

    it 'returns duplicate category' do
      mock_sub = double('sub intance')

      mock_plan_instance = double('plan factory')
      allow_any_instance_of(Factory).to receive(:category) { mock_plan_instance }
      allow(mock_plan_instance).to receive(:free).and_return('ADD FREE PLAN')

      subject.instance_variable_set(:@sub, mock_sub)
      allow(mock_sub).to receive(:start_date) { Date.today }
      allow(mock_sub).to receive(:category?) { true }

      result = subject.send(:add_subscription, 'MUSIC', 'free')
      expect(result).to eql 'ADD_SUBSCRIPTION_FAILED DUPLICATE_CATEGORY'
    end

    it 'adds subscription plan' do
      mock_sub = double('sub intance')

      mock_plan_instance = double('plan factory')
      allow_any_instance_of(Factory).to receive(:category) { mock_plan_instance }
      allow(mock_plan_instance).to receive(:free).and_return('ADD FREE PLAN')

      subject.instance_variable_set(:@sub, mock_sub)
      allow(mock_sub).to receive(:add_top_up).and_return('Add topup plan')
      allow(mock_sub).to receive(:start_date).and_return(Date.parse('03-10-2022'))
      allow(mock_sub).to receive(:category?).and_return(false)
      allow(mock_sub).to receive(:add_subscribed_plan).and_return('SUBSCRIPTION PLAN ADDED')

      result = subject.send(:add_subscription, 'MUSIC', 'free')
      expect(result).to eql 'SUBSCRIPTION PLAN ADDED'
    end
  end
end

describe Handler do
  describe '#add_date' do
    # TODO: mock `sub` instance varible
    it 'sets date object on `sub`, when valid date is provided' do
      allow_any_instance_of(Utils).to receive(:valid_date?) { Date.parse('05-02-2022') }

      subject.send(:add_date, '05-02-2022')
      expect(subject.sub.start_date).to eql Date.parse('05-02-2022')
    end

    # TODO: mock `sub` instance varible
    it 'sets INVALID_DATE on `sub`, when invalid date is provided' do
      allow_any_instance_of(Utils).to receive(:valid_date?) { false }

      subject.send(:add_date, '05-19-2022')
      expect(subject.sub.start_date).to eql 'INVALID_DATE'
    end
  end
end
