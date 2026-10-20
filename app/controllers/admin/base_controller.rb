module Admin
  class BaseController < ApplicationController
    include Pundit::Authorization

    before_action :authorize_admin

    rescue_from Pundit::NotAuthorizedError, with: :admin_not_authorized

    private
      def authorize_admin
        authorize :admin, :access?
      end

      def pundit_user
        Current.user
      end

      def admin_not_authorized
        render "admin/forbidden", status: :forbidden, layout: "admin"
      end
  end
end
