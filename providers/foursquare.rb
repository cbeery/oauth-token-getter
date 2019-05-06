# https://foursquare.com/developers/apps

# http://localhost:9292/foursquare/callback

FOURSQUARE_CLIENT_ID = ENV['FOURSQUARE_CLIENT_ID']
FOURSQUARE_CLIENT_SECRET = ENV['FOURSQUARE_CLIENT_SECRET']
CURRENT_API_VERSION = "20190501"

get '/foursquare/authorize' do
	url = "https://foursquare.com/oauth2/authenticate?client_id=#{FOURSQUARE_CLIENT_ID}&response_type=code&redirect_uri=#{url('/foursquare/callback')}"
	redirect to(url)
end

get '/foursquare/callback' do
	post_params = { client_id: 			FOURSQUARE_CLIENT_ID,
									client_secret: 	FOURSQUARE_CLIENT_SECRET, 
									code: 					params[:code],
									grant_type: 		'authorization_code',
									redirect_uri: 	url('/foursquare/callback')}

	response = Net::HTTP.post_form(URI("https://foursquare.com/oauth2/access_token"), post_params)

	@json = response.body
	@parsed_json = JSON.parse(@json)
	@token = @parsed_json['access_token']

	erb :"foursquare/index"
end

get '/foursquare/example' do
	response = Net::HTTP.get(URI("https://api.foursquare.com/v2/users/self?oauth_token=#{params[:token]}&v=#{CURRENT_API_VERSION}"))
	@json = response
	@parsed_json = JSON.parse(@json)
	erb :"foursquare/example"
end