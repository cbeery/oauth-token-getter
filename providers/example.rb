# Helpful comments

# Link to provider's developer account page
# https://www.dropbox.com/developers/apps/info/bvany5kvn5jfs0i

# Your callback URL
# http://localhost:9292/<provider>/callback

get '/<provider>/authorize' do
	url = ""
	redirect to(url)
end

get '/<provider>/callback' do
	erb :"<provider>/index"
end

get '/<provider>/example' do
	erb :"<provider>/example"
end
