# frozen_string_literal: true

require 'rspec'
require_relative '../../../lib/core/commands'

describe Core::Commands do
  describe '#initialize' do
    let(:stdin) { described_class.new }
    it 'contains empty commands' do
      expect(stdin.cmds).to match_array([])
    end
  end
end

describe Core::Commands do
  subject(:input) { described_class.new }
  describe '#add' do
    it 'should add string to command list' do
      input.add 'ADD_SUBSCRIPTION VIDEO PREMIUM'
      expect(input.cmds).to have_attributes(size: 1)
    end

    it 'increase size when new valid inputs are added' do
      input.add 'ADD_SUBSCRIPTION VIDEO PREMIUM'
      input.add 'ADD_TOPUP FOUR_DEVICE 2'
      input.add 'START_SUBSCRIPTION 05-02-2022'
      expect(input.cmds).to have_attributes(size: 3)
    end
  end
end

describe Core::Commands do
  subject(:input) { described_class.new }
  describe '#parse' do
    describe 'return hash size' do
      it 'contains size based on no of wods provided' do
        result = input.send(:parse, 'ADD_SUBSCRIPTION VIDEO PREMIUM')
        expect(result).to have_attributes(size: 3)
      end
    end

    describe 'should error when' do
      it 'raises error when empty input is provided' do
        expect { input.send(:parse, '') }.to raise_error.with_message('Error: invalid command specified ()')
      end

      it 'raises error when invalid input command is provided' do
        expect do
          input.send(:parse, 'UNKNOWN')
        end.to raise_error.with_message('Error: invalid command specified (UNKNOWN)')
      end
    end
  end
end

describe Core::Commands do
  subject(:input) { described_class.new }
  describe 'Set subscription date' do
    it 'returns command and start date' do
      result = input.send(:parse, 'START_SUBSCRIPTION  05-02-2022')
      expect(result).to include(cmd: Constants::START_SUBSCRIPTION, date: '05-02-2022')
    end

    it 'returns command and no start date' do
      result = input.send(:parse, 'START_SUBSCRIPTION   ')
      expect(result).to include(cmd: Constants::START_SUBSCRIPTION, date: nil)
    end
  end
end

describe Core::Commands do
  subject(:input) { described_class.new }
  describe 'Add subscription category' do
    it 'returns command, category and plan' do
      result = input.send(:parse, 'ADD_SUBSCRIPTION MUSIC PERSONAL')
      expect(result).to include(cmd: Constants::ADD_SUBSCRIPTION, category: 'MUSIC', plan: 'PERSONAL')
    end

    it 'returns command' do
      result = input.send(:parse, 'ADD_SUBSCRIPTION   ')
      expect(result).to include(cmd: Constants::ADD_SUBSCRIPTION, category: nil, plan: nil)
    end

    it 'returns command, category' do
      result = input.send(:parse, 'ADD_SUBSCRIPTION  PODCAST ')
      expect(result).to include(cmd: Constants::ADD_SUBSCRIPTION, category: 'PODCAST')
    end
  end
end
describe Core::Commands do
  subject(:input) { described_class.new }
  describe 'Add topup' do
    it 'returns command, name and months' do
      result = input.send(:parse, 'ADD_TOPUP FOUR_DEVICE 2')
      expect(result).to include(cmd: Constants::ADD_TOPUP, name: 'FOUR_DEVICE', months: 2)
    end

    it 'returns command' do
      result = input.send(:parse, 'ADD_TOPUP   ')
      expect(result).to include(cmd: Constants::ADD_TOPUP, name: nil, months: 0)
    end

    it 'returns command, name' do
      result = input.send(:parse, 'ADD_TOPUP FOUR_DEVICE')
      expect(result).to include(cmd: Constants::ADD_TOPUP, name: 'FOUR_DEVICE')
    end
  end
end

describe Core::Commands do
  subject(:input) { described_class.new }
  describe 'Print renewal details' do
    it 'ignore additional arguments' do
      result = input.send(:parse, 'PRINT_RENEWAL_DETAILS MUSIC PERSONAL')
      expect(result).to include(cmd: Constants::PRINT_RENEWAL_DETAILS)
    end

    it 'returns command' do
      result = input.send(:parse, 'PRINT_RENEWAL_DETAILS   ')
      expect(result).to include(cmd: Constants::PRINT_RENEWAL_DETAILS)
    end
  end
end
