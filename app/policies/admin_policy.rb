class AdminPolicy < ApplicationPolicy
  def access?
    user&.admin? == true
  end
end
