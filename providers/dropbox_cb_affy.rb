# https://www.dropbox.com/developers/apps/info/bvany5kvn5jfs0i

# http://localhost:9292/dropbox_cb_affy/callback

DROPBOX_CB_AFFY_CLIENT_ID = ENV['DROPBOX_CB_AFFY_CLIENT_ID']
DROPBOX_CB_AFFY_CLIENT_SECRET = ENV['DROPBOX_CB_AFFY_CLIENT_SECRET']
ACCOUNT_ID = ENV['DROPBOX_CB_AFFY_ACCOUNT_ID']
TEAM_MEMBER_ID = ENV['DROPBOX_CB_AFFY_TEAM_MEMBER_ID']

get '/dropbox_cb_affy/authorize' do
	url = "https://www.dropbox.com/oauth2/authorize?client_id=#{DROPBOX_CB_AFFY_CLIENT_ID}&response_type=code&redirect_uri=#{url('/dropbox_cb_affy/callback')}&force_reapprove=false"
	redirect to(url)
end

get '/dropbox_cb_affy/callback' do
	post_params = {client_id: DROPBOX_CB_AFFY_CLIENT_ID, client_secret: DROPBOX_CB_AFFY_CLIENT_SECRET, code: params[:code], grant_type: 'authorization_code', redirect_uri: url('/dropbox_cb_affy/callback')}

	response = Net::HTTP.post_form(URI("https://api.dropboxapi.com/oauth2/token"), post_params)

	@json = response.body
	@parsed_json = JSON.parse(@json)
	@token = @parsed_json['access_token']

	erb :"dropbox_cb_affy/index"
end

get '/dropbox_cb_affy/example' do
	@token = params[:token]
	# response = post_with_headers('https://api.dropboxapi.com/2/users/get_account', {account_id: @account_id}, {'Authorization' => "Bearer #{@token}", 'Content-Type' => 'application/json'}, true)
	response = post_with_headers('https://api.dropboxapi.com/2/users/get_account', {account_id: ACCOUNT_ID}, {'Authorization' => "Bearer #{@token}", 'Content-Type' => 'application/json', 'Dropbox-API-Select-User' => TEAM_MEMBER_ID}, true)
	@json = response.body
	@parsed_json = JSON.parse(@json)
	erb :"dropbox_cb_affy/example"
end
