#config/initalizers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], {
  scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar',
  access_type: 'offline',
  redirect_uri:'https://pencil-in-app.herokuapp.com/auth/google_oauth2/callback'
  }
end
