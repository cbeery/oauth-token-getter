# https://www.dropbox.com/developers/apps/info/bvany5kvn5jfs0i

# http://localhost:9292/dropbox/callback

DROPBOX_CLIENT_ID = ENV['DROPBOX_CLIENT_ID']
DROPBOX_CLIENT_SECRET = ENV['DROPBOX_CLIENT_SECRET']

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
