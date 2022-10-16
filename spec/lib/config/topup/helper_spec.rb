# frozen_string_literal: true

require 'rspec'
require_relative '../../../../lib/config/topup/helper'

describe Config::ToupHelper do
  let(:mock_class) { Class.new { extend Config::ToupHelper } }

  describe '#cost' do
    it 'returns total' do
      result = mock_class.cost(13, 2)
      expect(result).to eql(26)
    end
  end
end
