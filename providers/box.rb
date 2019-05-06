### Box
# https://app.box.com/developers/console/app/785738/configuration


# Notes/References
# https://stackoverflow.com/questions/40657465/accessing-box-api-using-refresh-token
# https://stackoverflow.com/questions/13926701/oauth-2-0-validity-of-refresh-token-in-box-v2-api
#
# - You can use refresh token to get access token
# - This returns a NEW refresh token to get access token the NEXT time
# - Need a way to save the refresh token


BOX_CLIENT_ID = ENV['BOX_CLIENT_ID']
BOX_CLIENT_SECRET = ENV['BOX_CLIENT_SECRET']

get '/box/authorize' do
	# url = "https://www.strava.com/oauth/authorize?client_id=#{STRAVA_CLIENT_ID}&response_type=code&scope=view_private&redirect_uri=#{url('/box/callback')}"
	# url = "https://www.strava.com/oauth/authorize?client_id=#{}&response_type=code&scope=activity:read_all,activity:write&redirect_uri=#{url('/box/callback')}"
	url = "https://account.box.com/api/oauth2/authorize?client_id=#{BOX_CLIENT_ID}&response_type=code&redirect_uri=#{url('/box/callback')}"
	redirect to(url)
end

get '/box/callback' do
	post_params = { client_id: 			BOX_CLIENT_ID,
									client_secret: 	BOX_CLIENT_SECRET, 
									code: 					params[:code],
									grant_type: 		'authorization_code'}

	response = Net::HTTP.post_form(
    # URI("https://account.box.com/api/oauth2/token"),
    URI("https://api.box.com/oauth2/token"),
    post_params
  )

	@json = response.body
	@parsed_json = JSON.parse(@json)
	@token = @parsed_json['access_token']

	erb :"box/index"
end

get '/box/example' do
	@token = params[:token]
	# response = Net::HTTP.get(URI("https://www.strava.com/api/v3/athlete/activities?access_token=#{@token}"))
	@json = response
	@parsed_json = JSON.parse(@json)
	erb :"box/example"
end
