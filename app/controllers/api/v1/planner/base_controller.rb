module Api
  module V1
    module Planner
      class BaseController < Api::V1::BaseController
        before_action :require_planner!
      end
    end
  end
end
