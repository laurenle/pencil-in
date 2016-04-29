class CalendarsController < ApplicationController
  def create
    # What data comes back from OmniAuth?     
    @auth = request.env["omniauth.auth"]
    #Use the token from the data to request a list of calendars
    @token = @auth["credentials"]["token"]
    client = Google::APIClient.new
    client.authorization.access_token = @token
    service = client.discovered_api('calendar', 'v3')
    result = client.execute(
      :api_method => service.freebusy.query,
      :body => JSON.dump({
          "timeMin" : DateTime.now.to_s,
          "timeMax" : (DateTime.now + 7.days).to_s,
          "items" : [
            {
              "id" : @auth["info"]["email"]
            }
          ]
        }),
      :headers => {'Content-Type' => 'application/json'})
    parse_freebusy(result)
  end

  def new
  end

  private 

  def parse_freebusy(result)
    @calendar = Calendar.create(:user_id => current_user.id)
    @calendar.events << Event.create(:start => DateTime.now,
      :end => DateTime.now + 5.hours)
    data = JSON.parse(result.body)
    cal_name, cal_data = data["calendars"].first
    cal_data["busy"].each do |time|
      event = create_event(DateTime.parse(time["start"]),
        DateTime.parse(time["end"]))
      @calendar.events << event if event.save
    end
  end

  def create_event(start_time, end_time)
    event = Event.new(:start => start_time,
      :end => end_time,
      :calendar_id => @calendar.id)
  end
end
