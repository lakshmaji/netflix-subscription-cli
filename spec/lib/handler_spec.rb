# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/handler'

describe Handler do
  describe '#initialize' do
    it 'has subscription class instance' do
      expect(subject.manager).to be_a Core::Manage
    end
  end
end

describe Handler do
  describe '#run' do
    it 'has subscription class instance' do
      allow_any_instance_of(Handler).to receive(:process_command) do
        'COMMAND OUTPUT'
      end

      command = Constants::START_SUBSCRIPTION
      option = '05-02-2022'

      result = subject.run([{ cmd: command, date: option }])
      expect(result).to match_array(['COMMAND OUTPUT'])
    end

    it 'should not return date instance' do
      allow_any_instance_of(Handler).to receive(:process_command) do
        Date.today
      end
      result = subject.run([{ cmd: Constants::PRINT_RENEWAL_DETAILS }])
      expect(result).to match_array([])
    end
  end
end

describe Handler do
  describe '#process_command' do
    describe 'start date' do
      it 'returns command operation result' do
        allow_any_instance_of(Core::Manage).to receive(:add_date) do |_ar|
          '05-02-2022'
        end

        result = subject.send(:process_command, cmd: Constants::START_SUBSCRIPTION, date: '05-02-2022')
        expect(result).to eql('05-02-2022')
      end
    end
  end
end

describe Handler do
  describe '#process_command' do
    describe 'add subscription' do
      it 'returns command operation result' do
        allow_any_instance_of(Core::Manage).to receive(:add_subscription) do |_ar|
          'SUBSCRIPTION ADDED'
        end

        result = subject.send(:process_command, cmd: Constants::ADD_SUBSCRIPTION, category: 'MUSIC',
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
        allow_any_instance_of(Core::Manage).to receive(:add_topup) do |_ar|
          'TOP UP ADDED'
        end

        result = subject.send(:process_command, cmd: Constants::ADD_TOPUP, name: 'DEVICE_4', months: 2)
        expect(result).to eql('TOP UP ADDED')
      end
    end
  end
end

describe Handler do
  describe '#process_command' do
    it 'returns string' do
      allow_any_instance_of(Core::Manage).to receive(:print_info) do |_ar|
        'sample putput string'
      end

      result = subject.send(:process_command, cmd: Constants::PRINT_RENEWAL_DETAILS)
      expect(result).to eql('sample putput string')
    end
  end
end
