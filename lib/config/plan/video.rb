# frozen_string_literal: true

module Config
  module Plan
    # Contains video category subscription plans free, premium and personal pricings.
    # The free plan pricing will be inherited from default or base plan.
    class VideoPlan < BasePlan
      @category = 'video'
      attr_accessor :amount, :time

      def personal
        @amount = 200
        @time = 1
      end

      def premium
        @amount = 500
        @time = 3
      end

      class << self
        attr_reader :category
      end
    end
  end
end
