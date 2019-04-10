### Strava
# https://www.strava.com/settings/api

STRAVA_CLIENT_ID = ENV['STRAVA_CLIENT_ID']
STRAVA_CLIENT_SECRET = ENV['STRAVA_CLIENT_SECRET']

get '/strava/authorize' do
	# url = "https://www.strava.com/oauth/authorize?client_id=#{STRAVA_CLIENT_ID}&response_type=code&scope=view_private&redirect_uri=#{url('/strava/callback')}"
	url = "https://www.strava.com/oauth/authorize?client_id=#{STRAVA_CLIENT_ID}&response_type=code&scope=activity:read_all,activity:write&redirect_uri=#{url('/strava/callback')}"
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
