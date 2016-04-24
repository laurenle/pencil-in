# app/models/token.rb

require 'net/http'
require 'json'

class Token < ActiveRecord::Base

  def to_params
    {'refresh_token' => refresh_token,
    'client_id' => ENV['CLIENT_ID'],
    'client_secret' => ENV['CLIENT_SECRET'],
    'grant_type' => 'refresh_token'}
  end

  def request_token_from_google
    uri = URI.parse("https://www.googleapis.com/oauth2/v3/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(self.to_params)
    http.request(request)
  end

  def refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    update_attributes(
      access_token: data['access_token'],
      expires_at: Time.now + (data['expires_in'].to_i).seconds)
  end

  def expired?
    expires_at < Time.now
  end

  def fresh_token
    refresh! if expired?
    access_token
  end

end