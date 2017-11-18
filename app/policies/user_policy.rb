class UserPolicy < ApplicationPolicy
  def sign_up?
    true
  end

  def sign_in?
    true
  end

  def update?
    user.is_admin? || user == record
  end

  def show?
    user.is_admin? || user == record
  end
end
