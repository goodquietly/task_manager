class UsersController < ApplicationController
  # GET /users/1
  def show
    @user = User.find(params[:id])
    @task = Task.new(user: @user)
    @tasks = Task.where(user: @user)
  end
end
