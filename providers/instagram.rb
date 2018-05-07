# Helpful comments

# Link to provider's developer account page
# https://www.instagram.com/developer/clients/9ca01e6879ac4883acb2d202a836d55a/edit/

# Your callback URL
# http://localhost:9292/instagram/callback

INSTAGRAM_CLIENT_ID = ENV['INSTAGRAM_CLIENT_ID']
INSTAGRAM_CLIENT_SECRET = ENV['INSTAGRAM_CLIENT_SECRET']

get '/instagram/authorize' do
	# url = "https://api.instagram.com/oauth/authorize/?client_id=#{INSTAGRAM_CLIENT_ID}&redirect_uri=#{url('/instagram/callback')}&response_type=code"
	url = "https://api.instagram.com/oauth/authorize/?client_id=#{INSTAGRAM_CLIENT_ID}&redirect_uri=#{url('/instagram/callback')}&response_type=code&scope=public_content"
	redirect to(url)
end

get '/instagram/callback' do
	post_params = {client_id: INSTAGRAM_CLIENT_ID, client_secret: INSTAGRAM_CLIENT_SECRET, code: params[:code], grant_type: 'authorization_code', redirect_uri: url('/instagram/callback')}

	response = Net::HTTP.post_form(URI("https://api.instagram.com/oauth/access_token"), post_params)

	@json = response.body
	@parsed_json = JSON.parse(@json)
	@token = @parsed_json['access_token']

	erb :"instagram/index"
end

get '/instagram/example' do
	# Do your shit
	@token = params[:token]
	response = Net::HTTP.get(URI("https://api.instagram.com/v1/users/self/media/recent?access_token=#{@token}"))
	@json = response
	@parsed_json = JSON.parse(@json)
	erb :"instagram/example"
end
