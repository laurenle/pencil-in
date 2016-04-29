class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @temp = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  # POST /tasks/confirm
  def confirm
    @temp = Task.new(task_params)
    @temp.start_time = next_avail(@temp.duration, params[:calendar_id])

    if @temp.save?
      redirect_to @temp
    else
      render :new
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  private

    def next_avail(mins, id)
      cal = Calendar.find(id)
      for i in 1..cal.size
        start_time = cal[i - 1][:end]
        end_time = cal[i][:begin]
        diff = (end_time - start_time).to_i
        break if diff <= mins
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def task_params
      params.require(:task).permit(:description, :start_time, :duration, :user_id)
    end
end
