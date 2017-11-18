class ReportPolicy < ApplicationPolicy
  def by_author?
    user.is_admin?
  end
end
