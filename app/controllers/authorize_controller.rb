class AuthorizeController < ApplicationController
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
          "timeMin": DateTime.now.to_s,
          "timeMax": (DateTime.now + 7.days).to_s,
          "items": [
            {
              "id": @auth["info"]["email"]
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
    @available = []
    data = JSON.parse(result.body)
    data["calendars"].each do |key, value|
      value["busy"].each do |time|
        @available << {:start => DateTime.parse(time["start"]),
          :end => DateTime.parse(time["end"])}
      end
    end
  end
end