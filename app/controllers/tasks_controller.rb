# Tasks Controller
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
    @temp = []
    5.times do
      @temp << Task.new
    end
    @calendar = Calendar.find(params[:calendar_id])
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @temp = Task.new(task_params)
    @calendar = Calendar.find(params[:calendar_id])
    @temp.start_time = next_avail(@temp.duration, @calendar)

    if @temp.save
      redirect_to @temp, notice: 'Task was successfully created.'
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

  def next_avail(mins, cal)
    cal.events.each_with_index do |event, i|
      break unless i < cal.events.size
      return cal.events[i].end unless time_difference_minutes(
        cal.events[i].end, event.start) < mins
    end
    nil
  end

  def time_difference_minutes(time1, time2)
    ((time1 - time2) * 24 * 60).to_i
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def task_params(my_params)
    my_params.permit(:description, :start_time, :duration, :user_id)
  end
end
