class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all
    @users = User.all
  end

  def show
    @user = @task.user
    @tasks = Task.where(user_id: @user.id)
  end

  def new
    @user = User.find(params[:id])
    @task = Task.new(user: @user)
  end

  def edit; end

  def create
    task_params = params.require(:task).permit(:title, :user_id)

    @task = Task.new(task_params)

    @task.author = current_user

    if @task.save

      redirect_to task_path(@task), notice: 'Задача успешно создана!'
    else
      flash.now[:alert] = 'Вы неправильно заполнили поле Title'

      render :new
    end
  end

  def update
    task_params = params.require(:task).permit(:title, :user_id)

    if @task.update(task_params)

      redirect_to task_path(@task), notice: 'Задача успешно обновлена!'
    else
      flash.now[:alert] = 'Вы неправильно заполнили поле Title'

      render :edit
    end
  end

  def destroy
    @task.destroy

    redirect_to root_path, notice: 'Задача успешно удалена.'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end
end
