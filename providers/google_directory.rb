# http://localhost:9292/google_directory/callback

GOOGLE_DIRECTORY_CLIENT_ID = ENV['GOOGLE_DIRECTORY_CLIENT_ID']
GOOGLE_DIRECTORY_CLIENT_SECRET = ENV['GOOGLE_DIRECTORY_CLIENT_SECRET']

get '/google_directory/authorize' do
	url = "https://accounts.google.com/o/oauth2/auth?access_type=offline&approval_prompt=force&client_id=#{GOOGLE_DIRECTORY_CLIENT_ID}&redirect_uri=#{url('/google_directory/callback')}&response_type=code&scope=https://www.googleapis.com/auth/admin.directory.user.readonly,https://www.googleapis.com/auth/admin.directory.user"
	redirect to(url)

end

get '/google_directory/callback' do
	post_params = {client_id: GOOGLE_DIRECTORY_CLIENT_ID, client_secret: GOOGLE_DIRECTORY_CLIENT_SECRET, code: params[:code], grant_type: 'authorization_code', redirect_uri: url('/google_directory/callback')}

	response = Net::HTTP.post_form(URI("https://accounts.google.com/o/oauth2/token"), post_params)

	@json = response.body
	@parsed_json = JSON.parse(@json)
	@token = @parsed_json['access_token']

	erb :"google_directory/index"
end

get '/google_directory/example' do
	erb :"google_directory/example"
end
