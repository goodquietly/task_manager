class TaskMailer < ApplicationMailer
  def new_task(task)
    @task = task

    bootstrap_mail to: task.user.email
  end

  def update_status(task)
    @task = task

    bootstrap_mail to: task.author.email
  end

  def destroy_task(task)
    @task = task

    bootstrap_mail to: task.user.email
  end
end
