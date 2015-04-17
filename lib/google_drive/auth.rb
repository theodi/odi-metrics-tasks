require 'google_drive'
require 'dotenv'

Dotenv.load

class GoogleDriveAuth

  attr_reader :session

  def initialize
    access_token = get_token
    @session = login(access_token)
  end

  def login(access_token)
    GoogleDrive.login_with_oauth(access_token)
  end

  def client
    Google::APIClient.new(
      :application_name => 'ODI Metrics Tasks',
      :application_version => '1.0.0'
    )
  end

  def get_auth
    auth = client.authorization
    auth.client_id = ENV['GAPPS_CLIENT_ID']
    auth.client_secret = ENV['GAPPS_CLIENT_SECRET']
    auth.scope = "https://docs.google.com/feeds/" +
                 "https://www.googleapis.com/auth/drive " +
                 "https://spreadsheets.google.com/feeds/"

    auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
    auth
  end

  def get_token
    auth = get_auth

    auth.refresh_token = ENV['GAPPS_REFRESH_TOKEN']
    auth.refresh!

    auth.access_token
  end

end
