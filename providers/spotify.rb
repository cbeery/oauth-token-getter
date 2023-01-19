### Spotify
# https://developer.spotify.com/documentation/web-api/

SPOTIFY_CLIENT_ID = ENV['SPOTIFY_CLIENT_ID']
SPOTIFY_CLIENT_SECRET = ENV['SPOTIFY_CLIENT_SECRET']

###
# TODO - Learn about Spotify Web API rate limits
###

get '/spotify/authorize' do
	
	scopes = 'user-read-private user-read-email'
	redirect_uri = url('/spotify/callback')

	url = "https://accounts.spotify.com/authorize?client_id=#{SPOTIFY_CLIENT_ID}&response_type=code&scope=#{scopes}&redirect_uri=#{redirect_uri}"

	redirect to(url)
end

get '/spotify/callback' do
	post_params = { client_id: 			SPOTIFY_CLIENT_ID,
									client_secret: 	SPOTIFY_CLIENT_SECRET,
									grant_type: 		'authorization_code',
									redirect_uri: 	url('/spotify/callback'),
									code: 					params[:code]}

	response = Net::HTTP.post_form(
    URI("https://accounts.spotify.com/api/token"),
    post_params
  )

	@json = response.body
	@parsed_json = JSON.parse(@json)
	@token = @parsed_json['access_token']

	erb :"spotify/index"
	# erb :"spotify/index-temp"
end

get '/spotify/refresh_token' do
	post_params = { client_id: 			SPOTIFY_CLIENT_ID,
									client_secret: 	SPOTIFY_CLIENT_SECRET,
									grant_type: 		'refresh_token',
									refresh_token: 	params[:refresh_token]}

	response = Net::HTTP.post_form(
    URI("https://accounts.spotify.com/api/token"),
    post_params
  )

	@json = response.body
	@parsed_json = JSON.parse(@json)
	@token = @parsed_json['access_token']	

	erb :"spotify/index"
end

get '/spotify/example' do
	@token = params[:token]
	response = Net::HTTP.get(URI("https://api.spotify.com/v1/me?access_token=#{@token}"))
	@json = response
	@parsed_json = JSON.parse(@json)
	erb :"spotify/example"
end
