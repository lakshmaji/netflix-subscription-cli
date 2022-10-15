# frozen_string_literal: true

require 'rspec'
require_relative '../../../lib/utils/date'

describe Utils do
  describe '#valid_date?' do
    context 'returns valid date string' do
      it 'with default format' do
        result = Utils.valid_date? '20-02-2022'
        expect(result).to eq Date.parse('20-02-2022')
      end

      it 'with custom format' do
        result = Utils.valid_date? '20, 2022 02', '%d, %Y %m'
        expect(result).to eq Date.parse('20-02-2022')
      end
    end

    context 'returns false for invalid input' do
      it 'with default format' do
        result = subject.valid_date? '20-22-2022'
        expect(result).to be_falsy
      end

      it 'with custom format' do
        result = subject.valid_date? '32, 2022 02', '%d, %Y %m'
        expect(result).to be_falsy
      end
    end
  end
end
