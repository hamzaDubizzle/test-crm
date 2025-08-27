class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    # Bad practice: no proper filtering or pagination
    @tasks = current_user.tasks.all
  end

  def show
    # Bad practice: no proper error handling
  end

  def new
    @task = Task.new
    # Bad practice: no proper customer/deal selection
    @customers = current_user.customers.all
    @deals = current_user.deals.all
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    # Bad practice: no proper error handling
    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      @customers = current_user.customers.all
      @deals = current_user.deals.all
      render :new
    end
  end

  def edit
    # Bad practice: no proper error handling
    @customers = current_user.customers.all
    @deals = current_user.deals.all
  end

  def update
    # Bad practice: no proper error handling
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      @customers = current_user.customers.all
      @deals = current_user.deals.all
      render :edit
    end
  end

  def destroy
    # Bad practice: no proper error handling
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  private

  def set_task
    # Bad practice: no proper error handling
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    # Bad practice: no proper parameter filtering
    params.require(:task).permit(:title, :description, :due_date, :priority, :status, :customer_id, :deal_id)
  end
end
