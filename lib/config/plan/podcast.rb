# frozen_string_literal: true

module Config
  module Plan
    # Contains pod cast category subscription plans free, premium and personal pricings.
    # The free plan pricing will be inherited from default or base plan.
    class PodcastPlan < BasePlan
      @category = 'podcast'
      attr_accessor :amount, :time

      def personal
        @amount = 100
        @time = 1
      end

      def premium
        @amount = 300
        @time = 2
      end

      class << self
        attr_reader :category
      end
    end
  end
end
