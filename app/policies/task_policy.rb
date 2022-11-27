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
    user == record.author && !record.finished?
  end

  def update_status?
    user == record.user && !record.finished?
  end

  def destroy?
    user == record.user && !record.finished?
  end
end
