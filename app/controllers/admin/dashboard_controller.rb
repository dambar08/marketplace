module Admin
  class DashboardController < BaseController
    def show
      @dashboard = Admin::Dashboard.new
    end
  end
end
