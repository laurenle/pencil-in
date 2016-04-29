# Tasks Controller
class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :add_users_task]

  # GET /tasks
  def index
    @tasks = current_user.tasks.sort_by { |obj| obj.start_time }
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

  def add_users_task
    friend = User.find_by email: params[:email]
    if friend.present?
      @task.users << friend
      flash[:success] = "Successfully added user #{friend.email}!"
    else
      flash[:failure] = "Error: No record of such email exists."
    end
    redirect_to @task
  end

  # POST /tasks
  def create
    @calendar = current_user.calendar
    add_bedtime(params[:sleep_start], params[:sleep_end])
    params["tasks"].each do |task|
      task_new = Task.new(task_params(task))
      task_new.start_time = next_avail(task_new.duration, @calendar) unless task_new.duration.nil?
      if task_new.save
        current_user.tasks << task_new
        @calendar.events << task_to_event(task_new)
      end
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
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
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

  def add_bedtime(sleep_start, sleep_end)
    date = DateTime.now.beginning_of_day
    6.times do 
      event = Event.create(
        start: date + Time.parse(sleep_start).seconds_since_midnight.seconds,
        end: date + Time.parse(sleep_end).seconds_since_midnight.seconds,
        calendar_id: current_user.calendar.id)
      date = (date + 1.days).to_datetime
      current_user.calendar.events << event
    end
  end

  def time_difference_minutes(time1, time2)
    ((time1 - time2) / 1.minute).to_i
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
    my_params.permit(:description, :start_time, :duration)
  end
end
