class TasksController < ApplicationController
  before_action :set_task, only: %i[ edit update destroy ]

  def index
    @tasks = Task.ordered
  end

  def new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.turbo_stream
        format.html { redirect_to tasks_path, notice: "Task was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@task)}_form", partial: "form", locals: { task: @task }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@task)}_item", @task) }
        format.html { redirect_to tasks_path, notice: "Task was successfully updated.", status: :see_other }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@task)}_item") }
      format.html { redirect_to tasks_path, notice: "Task was successfully destroyed.", status: :see_other }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :status)
  end
end
