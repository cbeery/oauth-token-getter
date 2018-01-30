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

### Strava
# https://www.strava.com/settings/api

get '/strava/authorize' do
	# url = "https://www.strava.com/oauth/authorize?client_id=#{STRAVA_CLIENT_ID}&response_type=code&redirect_uri=#{url('/strava/callback')}&approval_prompt=force"
	url = "https://www.strava.com/oauth/authorize?client_id=#{STRAVA_CLIENT_ID}&response_type=code&redirect_uri=#{url('/strava/callback')}"
	redirect to(url)
end

get '/strava/callback' do
	post_params = { client_id: 			STRAVA_CLIENT_ID,
									client_secret: 	STRAVA_CLIENT_SECRET, 
									code: 					params[:code]}

	response = Net::HTTP.post_form(
    URI("https://www.strava.com/oauth/token"),
    post_params
  )

	@json = response.body
	@parsed_json = JSON.parse(@json)
	@token = @parsed_json['access_token']

	erb :"strava/index"
end

get '/strava/example' do
	@token = params[:token]
	response = Net::HTTP.get(URI("https://www.strava.com/api/v3/athlete/activities?access_token=#{@token}"))
	@json = response
	@parsed_json = JSON.parse(@json)
	erb :"strava/example"
end




# https://www.dropbox.com/developers/apps/info/bvany5kvn5jfs0i

# http://localhost:9292/dropbox/callback

get '/dropbox/authorize' do
	url = "https://www.dropbox.com/oauth2/authorize?client_id=#{DROPBOX_CLIENT_ID}&response_type=code&redirect_uri=#{url('/dropbox/callback')}&force_reapprove=false"
	redirect to(url)
end

get '/dropbox/callback' do
	post_params = {client_id: DROPBOX_CLIENT_ID, client_secret: DROPBOX_CLIENT_SECRET, code: params[:code], grant_type: 'authorization_code', redirect_uri: url('/dropbox/callback')}

	response = Net::HTTP.post_form(URI("https://api.dropboxapi.com/oauth2/token"), post_params)

	@json = response.body
	@parsed_json = JSON.parse(@json)
	@token = @parsed_json['access_token']

	erb :"dropbox/index"
end

get '/dropbox/example' do
	@token = params[:token]
	@account_id = params[:account_id]
	response = post_with_headers('https://api.dropboxapi.com/2/users/get_account', {account_id: @account_id}, {'Authorization' => "Bearer #{@token}", 'Content-Type' => 'application/json'}, true)
	@json = response.body
	@parsed_json = JSON.parse(@json)
	erb :"dropbox/example"
end

get '/test' do
	test_me('fucker')
end

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

def test_me(arg)
	"Hello, #{arg}!"
end

