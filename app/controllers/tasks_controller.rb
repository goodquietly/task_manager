class TasksController < ApplicationController
  def index
    @tasks = policy_scope(Task.active)
    @users = policy_scope(User)
  end

  def show
    @user = task.user
    @tasks = Task.where(user_id: @user.id)
  end

  def new
    authorize Task

    @user = User.find(params[:id])
    @task = Task.new(user: @user)
  end

  def edit
    @task = task
  end

  def create
    @task = authorize Task.new(task_params)

    @task.author = current_user

    if @task.save
      TaskMailer.new_task(@task).deliver_later

      redirect_to task_path(@task), notice: 'Task successfully created!'
    else
      render :new
    end
  end

  def update
    if task.update(task_params)
      task.created!

      TaskMailer.new_task(task).deliver_later

      redirect_to task_path(task), notice: 'The task has been successfully updated!'
    else
      render :edit
    end
  end

  def update_status
    if task.created?
      task.started!
    else
      task.finished!
    end

    TaskMailer.update_status(task).deliver_later

    redirect_to task_path, notice: 'Task status changed!'
  end

  def destroy
    task_info = task

    task.destroy
    TaskMailer.destroy_task(task_info).deliver_later

    redirect_to root_path, notice: 'The task was successfully deleted.'
  end

  private

  def task
    @task ||= authorize Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :user_id)
  end
end
