require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/partial'
require 'sass'
require 'json'
require 'net/http'
require 'signet/oauth_2/client' # For Google OAuth

# ENV

# Sinatra partial config
set :partial_template_engine, :erb
enable :partial_underscores

# SASS setup
get('/styles.css'){ scss :styles }

get '/' do
  erb :index
end

# Resources / Providers
load 'providers/strava.rb'
load 'providers/dropbox.rb'
load 'providers/instagram.rb'
load 'providers/google_drive.rb'
load 'providers/google_drive_cb.rb'
load 'providers/box.rb'
load 'providers/foursquare.rb'
load 'providers/google_directory.rb'
load 'providers/dropbox_cb_affy.rb'
load 'providers/spotify.rb'

private

def post_with_headers(post_url, data, headers, ssl)
	url = URI.parse(post_url)
  http = Net::HTTP.new(url.host, url.port)
  if ssl
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  response = http.post(url.path, data.to_json, headers)
  # response = http.post(url.path, data, headers)
end
