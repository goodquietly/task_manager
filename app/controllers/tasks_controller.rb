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
    @user = User.find(params[:id])
    @task = authorize Task.new(user: @user)
  end

  def edit; end

  def create
    task_params = params.require(:task).permit(:title, :user_id)

    @task = authorize Task.new(task_params)

    @task.author = current_user

    if @task.save
      TaskMailer.new_task(@task).deliver_now

      redirect_to task_path(@task), notice: 'Задача успешно создана!'
    else
      flash.now[:alert] = 'Вы неправильно заполнили поле Title'

      render :new
    end
  end

  def update
    return redirect_to task_path, alert: 'Задача выполнена, eё нельзя изменить.' if @task.finished?

    task_params = params.require(:task).permit(:title, :user_id)

    if @task.update(task_params)
      @task.created!

      TaskMailer.new_task(@task).deliver_now

      redirect_to task_path(@task), notice: 'Задача успешно обновлена!'
    else
      flash.now[:alert] = 'Вы неправильно заполнили поле Title'

      render :edit
    end
  end

  def update_status
    return redirect_to user_path, alert: 'Задача уже выполнена!' if @task.finished?

    if @task.created?
      @task.started!
    else
      @task.finished!
    end

    TaskMailer.update_status(@task).deliver_now

    redirect_to user_path, notice: 'Статус задачи изменен!'
  end

  def destroy
    @task.destroy

    redirect_to root_path, notice: 'Задача успешно удалена.'
  end

  private

  def set_task
    @task = authorize Task.find(params[:id])
  end
end
