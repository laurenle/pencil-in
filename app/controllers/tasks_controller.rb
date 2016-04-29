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
    @calendar = current_user.calendar
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @calendar = current_user.calendar

    params["tasks"].each do |task|
      task_new = Task.new(task_params(task))
      task_new.start_time = next_avail(task_new.duration, @calendar) unless task_new.duration.nil?
      @calendar.events << task_to_event(task_new) if task_new.save
    end
    redirect_to '/tasks'
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  private

  def next_avail(mins, cal)
    sorted = cal.events.sort_by { |obj| obj.start }
    sorted.each_with_index do |event, i|
      break unless i + 1 < cal.events.size
      return event.end unless time_difference_minutes(
        sorted[i + 1].start, event.end) < mins
    end
    nil
  end

  def time_difference_minutes(time1, time2)
    ((time1 - time2) * 24 * 60).to_i
  end

  def task_to_event(task)
    Event.new(start: task.start_time, end: (task.start_time + task.duration.minutes))
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
