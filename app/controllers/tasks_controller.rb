class TasksController < ApplicationController

  def show
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    if request.xhr?
      @task.save
      render json: @task
    else
      redirect_to root_path
    end
  end

  def new
    @task = Task.new
    render :new
  end

  def index
    @task = Task.new
    @user_tasks = session_logged_in? ? Task.where(user_id:  session_user.id).last(10) : nil
    @update_user_path = session_logged_in? ? "/users/#{session_user.id}" : ""
    render :index
  end

  def update
    task_id = params[:id].to_i
    task = Task.find(task_id)
    Task.update(task_id, :completed => !task.completed)
    task = Task.find(task_id)
    if request.xhr?
      render json: task.completed
    else
      redirect_to root_path
    end
  end

  private
    def task_params
      params.require(:task).permit(:user_id, :submitted_task)
    end
end
