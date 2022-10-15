# frozen_string_literal: true

require_relative '../config/plan/music'
require_relative '../config/plan/podcast'
require_relative '../config/plan/video'

module Factory
  def category(category)
    case category
    when 'MUSIC'
      Config::Plan::MusicPlan.new
    when 'VIDEO'
      Config::Plan::VideoPlan.new
    when 'PODCAST'
      Config::Plan::PodcastPlan.new
    end
  end
  module_function :category
end
