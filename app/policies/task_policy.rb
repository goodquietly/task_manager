class TaskPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def new?
    user.present?
  end

  def edit?
    update?
  end

  def create?
    user.present?
  end

  def update?
    user == record.author
  end

  def update_status?
    user == record.user
  end

  def destroy?
    update?
  end
end
