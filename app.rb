require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/partial'
require 'sass'
require 'json'
require 'net/http'

# ENV
STRAVA_CLIENT_ID = ENV['STRAVA_CLIENT_ID']
STRAVA_CLIENT_SECRET = ENV['STRAVA_CLIENT_SECRET']
DROPBOX_CLIENT_ID = ENV['DROPBOX_CLIENT_ID']
DROPBOX_CLIENT_SECRET = ENV['DROPBOX_CLIENT_SECRET']

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
