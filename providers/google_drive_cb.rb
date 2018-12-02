# http://gmile.me/simple-google-auth/
# https://console.developers.google.com/apis/credentials?project=affy-access-drive

# http://localhost:9292/google_drive/callback

GOOGLE_DRIVE_CB_CLIENT_ID = ENV['GOOGLE_DRIVE_CB_CLIENT_ID']
GOOGLE_DRIVE_CB_CLIENT_SECRET = ENV['GOOGLE_DRIVE_CB_CLIENT_SECRET']

get '/google_drive_cb/authorize' do
	url = "https://accounts.google.com/o/oauth2/auth?access_type=offline&approval_prompt=force&client_id=#{GOOGLE_DRIVE_CB_CLIENT_ID}&redirect_uri=#{url('/google_drive_cb/callback')}&response_type=code&scope=https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/spreadsheets.readonly"
	redirect to(url)

end

get '/google_drive_cb/callback' do
	post_params = {client_id: GOOGLE_DRIVE_CB_CLIENT_ID, client_secret: GOOGLE_DRIVE_CB_CLIENT_SECRET, code: params[:code], grant_type: 'authorization_code', redirect_uri: url('/google_drive_cb/callback')}

	response = Net::HTTP.post_form(URI("https://accounts.google.com/o/oauth2/token"), post_params)

	@json = response.body
	@parsed_json = JSON.parse(@json)
	@token = @parsed_json['access_token']

	erb :"google_drive_cb/index"
end

get '/google_drive_cb/example' do
	erb :"google_drive_cb/example"
end
