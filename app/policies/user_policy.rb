class UserPolicy < ApplicationPolicy
  def sign_up?
    true
  end

  def sign_in?
    true
  end

  def show?
    user.present? && user == record || user.is_admin?
  end

  def update?
    show?
  end
end
