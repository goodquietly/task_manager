class TasksController < ApplicationController
  # skip_before_action :authenticate_user!, only: %i[show edit update destroy index]

  # GET /tasks
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  def show
    @task = Task.find(params[:id])
  end

  # GET /tasks/new
  def new
    @user = User.find(params[:user_id])
    @task = Task.new(user: @user)
  end

  # GET /tasks/1/edit
  def edit; end

  # POST /tasks
  def create
    task_params = params.require(:task).permit(:title, :user_id)

    @task = Task.new(task_params)

    @task.author = current_user

    if @task.save

      redirect_to task_path(@task), notice: 'Task was successfully created!'
    else
      flash.now[:alert] = 'Вы неправильно заполнили поле Title'

      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    task_params = params.require(:task).permit(:title, :user_id)

    if @task.update(task_params)

      redirect_to task_path(@task), notice: 'Task was successfully updated!'
    else
      flash.now[:alert] = 'Вы неправильно заполнили поле Title'

      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy

    redirect_to root, notice: 'Task was successfully destroyed.'
  end
end
