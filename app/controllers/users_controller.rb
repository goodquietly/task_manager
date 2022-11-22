class UsersController < ApplicationController
  def show
    @user = authorize User.find(params[:id])
    @task = Task.new(user: @user)
    @tasks = Task.where(user: @user)
  end
end
