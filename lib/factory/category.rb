# frozen_string_literal: true

require_relative '../config/plan/music'
require_relative '../config/plan/podcast'
require_relative '../config/plan/video'

# Factory method, which will return instance for subscription category
module Factory
  def category_plan(category, plan)
    plan_category = category_instance(category)
    return nil if plan_category.nil?

    # call plan on the specific category
    plan_category.method(plan.downcase.to_sym).call
    plan_category
  end
  module_function :category_plan

  def self.category_instance(category)
    case category
    when 'MUSIC'
      Config::Plan::MusicPlan.new
    when 'VIDEO'
      Config::Plan::VideoPlan.new
    when 'PODCAST'
      Config::Plan::PodcastPlan.new
    end
  end
end
