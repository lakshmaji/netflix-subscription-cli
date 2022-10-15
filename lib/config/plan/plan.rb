# frozen_string_literal: true

module Config
  module Plan
    # Contains free plan pricing for all categories (trial period of 1 month).
    # The `renewal_date` will evaluate the renewal date since the date of initial subscription.
    class BasePlan
      REMAINDER_BUFFER_PERIOD = 10 # in days

      attr_accessor :amount, :time

      def free
        @amount = 0
        @time = 1 # in months
      end

      def personal
        raise 'Implement personal method'
      end

      def premium
        raise 'Implement premuim method'
      end

      def renewal_date(subscribed_date)
        ends_on = subscribed_date.next_month(time)
        renewalble_remainder_date = ends_on - REMAINDER_BUFFER_PERIOD
        renewalble_remainder_date.strftime('%d-%m-%Y')
      end
    end
  end
end
