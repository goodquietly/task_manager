class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy update_status]

  def index
    @tasks = policy_scope(Task)
    @users = policy_scope(User)
  end

  def show
    @user = @task.user
    @tasks = Task.where(user_id: @user.id)
  end

  def new
    authorize Task

    @user = User.find(params[:id])
    @task = Task.new(user: @user)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'The user with the given ID does not exist! Choose another.'
  end

  def edit; end

  def create
    task_params = params.require(:task).permit(:title, :user_id)

    @task = authorize Task.new(task_params)

    @task.author = current_user

    if @task.save
      TaskMailer.new_task(@task).deliver_now

      redirect_to task_path(@task), notice: 'Task successfully created!'
    else
      flash.now[:alert] = 'You filled in the Title field incorrectly'

      render :new
    end
  end

  def update
    task_params = params.require(:task).permit(:title, :user_id)

    if @task.update(task_params)
      @task.created!

      TaskMailer.new_task(@task).deliver_now

      redirect_to task_path(@task), notice: 'The task has been successfully updated!'
    else
      flash.now[:alert] = 'You filled in the Title field incorrectly.'

      render :edit
    end
  end

  def update_status
    if @task.created?
      @task.started!
    else
      @task.finished!
    end

    TaskMailer.update_status(@task).deliver_now

    redirect_to task_path, notice: 'Task status changed!'
  end

  def destroy
    task_info = @task

    @task.destroy

    TaskMailer.destroy_task(task_info).deliver_now

    redirect_to root_path, notice: 'The task was successfully deleted.'
  end

  private

  def set_task
    @task = authorize Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'The task with the given ID does not exist! Choose another.'
  end
end
