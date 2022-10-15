# frozen_string_literal: true

require_relative 'plan'
module Config
  module Plan
    # Contains music category subscription plans free, premium and personal pricings.
    # The free plan pricing will be inherited from default or base plan.
    class MusicPlan < BasePlan
      @category = 'music'
      attr_accessor :amount, :time

      def personal
        @amount = 100
        @time = 1
      end

      def premium
        @amount = 250
        @time = 3
      end

      class << self
        attr_reader :category
      end
    end
  end
end
