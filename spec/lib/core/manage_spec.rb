# frozen_string_literal: true

require 'rspec'
require_relative '../../../lib/core/manage'

describe Core::Manage do
  describe '#initialize' do
    it 'has subscription class instance' do
      expect(subject.subscription).to be_a Core::Subscription
    end
  end
end

describe Core::Manage do
  describe '#print_info' do
    context 'when no subscriptions are added' do
      it 'returns subscription not found' do
        mock_sub = double('subscription instance')

        subject.instance_variable_set(:@subscription, mock_sub)
        allow(mock_sub).to receive(:subscribed_plans).and_return([])

        result = subject.print_info String.new
        expect(result).to eql(Constants::SUBSCRIPTIONS_NOT_FOUND)
      end
    end

    context 'when subscriptions are added' do
      it 'returns renewal details' do
        mock_sub = double('subscription instance')

        subject.instance_variable_set(:@subscription, mock_sub)
        allow(mock_sub).to receive(:subscribed_plans).and_return(['plan 1'])
        allow(mock_sub).to receive(:total_price) { 600 }

        allow(Constants).to receive(:renewal_remainder).and_return("renewal date for subscriptions.\n")

        result = subject.send(:print_info, String.new)
        expect(result).to eql("renewal date for subscriptions.\nRENEWAL_AMOUNT 600\n")
      end
    end
  end
end

describe Core::Manage do
  describe '#add_topup' do
    it 'fails with invalid date' do
      mock_sub = double('subscription intance')
      mock_topup_instance = double('topup factory')

      subject.instance_variable_set(:@subscription, mock_sub)
      allow(Factory).to receive(:top_up) { mock_topup_instance }
      allow(mock_sub).to receive(:start_date).and_return(Constants::INVALID_DATE)

      result = subject.send(:add_topup, 'FOUR_DEVICE', 2)
      expect(result).to eql Constants::ADD_TOPUP_FAILED_INVALID_DATE
    end

    it 'fails with duplicate topup' do
      mock_sub = double('subscription intance')

      subject.instance_variable_set(:@subscription, mock_sub)
      allow(Factory).to receive(:top_up) { mock_topup_instance }
      allow(mock_sub).to receive(:start_date).and_return(Date.parse('05-02-2022'))
      allow(mock_sub).to receive(:top_up?).and_return(true)

      result = subject.send(:add_topup, 'FOUR_DEVICE', 2)
      expect(result).to eql Constants::DUPLICATE_TOPUP
    end

    it 'adds top up to subscription instance' do
      mock_plan = double('plan factory')
      mock_sub = double('subscription intance')
      mock_topup_instance = double('topup factory')

      subject.instance_variable_set(:@subscription, mock_sub)
      allow(Factory).to receive(:top_up) { mock_topup_instance }
      allow(mock_plan).to receive(:new).and_return('TOUP instance')
      allow(mock_sub).to receive(:add_top_up).and_return('Added topup plan')
      allow(mock_sub).to receive(:start_date).and_return(Date.parse('05-02-2022'))
      allow(mock_sub).to receive(:top_up?).and_return(false)

      result = subject.send(:add_topup, 'FOUR_DEVICE', 2)
      expect(result).to eql 'Added topup plan'
    end
  end
end

describe Core::Manage do
  describe '#add_subscription' do
    it 'returns invalid date' do
      mock_sub = double('subscription intance')

      mock_plan_instance = double('plan factory')
      allow_any_instance_of(Factory).to receive(:category_plan) { mock_plan_instance }
      # allow(mock_plan_instance).to receive(:free).and_return('ADD FREE PLAN')

      subject.instance_variable_set(:@subscription, mock_sub)
      allow(mock_sub).to receive(:start_date).and_return(Constants::INVALID_DATE)

      result = subject.send(:add_subscription, 'MUSIC', 'free')
      expect(result).to eql Constants::ADD_SUBSCRIPTION_FAILED_INVALID_DATE
    end

    it 'returns duplicate category' do
      mock_sub = double('subscription intance')

      mock_plan_instance = double('plan factory')
      allow_any_instance_of(Factory).to receive(:category_plan) { mock_plan_instance }
      # allow(mock_plan_instance).to receive(:free).and_return('ADD FREE PLAN')

      subject.instance_variable_set(:@subscription, mock_sub)
      allow(mock_sub).to receive(:start_date) { Date.today }
      allow(mock_sub).to receive(:category?) { true }

      result = subject.send(:add_subscription, 'MUSIC', 'free')
      expect(result).to eql Constants::ADD_SUBSCRIPTION_FAILED_DUPLICATE_CATEGORY
    end

    it 'adds subscription plan' do
      mock_sub = double('subscription intance')

      mock_plan_instance = double('plan factory')
      allow_any_instance_of(Factory).to receive(:category_plan) { mock_plan_instance }
      # allow(mock_plan_instance).to receive(:free).and_return('ADD FREE PLAN')

      subject.instance_variable_set(:@subscription, mock_sub)
      allow(mock_sub).to receive(:add_top_up).and_return('Add topup plan')
      allow(mock_sub).to receive(:start_date).and_return(Date.parse('03-10-2022'))
      allow(mock_sub).to receive(:category?).and_return(false)
      allow(mock_sub).to receive(:add_subscribed_plan).and_return('SUBSCRIPTION PLAN ADDED')

      result = subject.send(:add_subscription, 'MUSIC', 'free')
      expect(result).to eql 'SUBSCRIPTION PLAN ADDED'
    end
  end
end

describe Core::Manage do
  describe '#add_date' do
    it 'sets date object on `subscription`, when valid date is provided' do
      allow(Utils).to receive(:valid_date?) { Date.parse('05-02-2022') }

      mock_sub = double('subscription instance')
      subject.instance_variable_set(:@subscription, mock_sub)
      allow(mock_sub).to receive(:add_starts_on) do
        Date.parse('05-02-2022')
      end

      result = subject.send(:add_date, '05-02-2022')
      expect(result).to eql Date.parse('05-02-2022')
    end

    it 'sets INVALID_DATE on `subscription`, when invalid date is provided' do
      mock_sub = double('subscription instance')
      subject.instance_variable_set(:@subscription, mock_sub)
      allow(mock_sub).to receive(:add_starts_on) do
        Constants::INVALID_DATE
      end

      allow(Utils).to receive(:valid_date?) { false }

      result = subject.send(:add_date, '05-19-2022')
      expect(result).to eql Constants::INVALID_DATE
    end
  end
end

describe Core::Manage do
  describe '#print_info' do
    context 'when no subscriptions are added' do
      it 'returns subscription not found' do
        mock_sub = double('subscription instance')

        subject.instance_variable_set(:@subscription, mock_sub)
        allow(mock_sub).to receive(:subscribed_plans).and_return([])

        result = subject.send(:print_info, String.new)
        expect(result).to eql(Constants::SUBSCRIPTIONS_NOT_FOUND)
      end
    end

    context 'when subscriptions are added' do
      it 'returns renewal details' do
        mock_sub = double('subscription instance')

        subject.instance_variable_set(:@subscription, mock_sub)
        allow(mock_sub).to receive(:subscribed_plans).and_return(['plan 1'])
        allow(mock_sub).to receive(:total_price) { 600 }
        allow(Constants).to receive(:renewal_remainder).and_return("renewal date for subscriptions.\n")

        result = subject.print_info String.new
        expect(result).to eql("renewal date for subscriptions.\nRENEWAL_AMOUNT 600\n")
      end
    end
  end
end
