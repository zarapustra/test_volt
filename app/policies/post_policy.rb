class PostPolicy < ApplicationPolicy
  def create?
    user.is_client?
  end

  def show?
    true
  end

  def index?
    show?
  end
end