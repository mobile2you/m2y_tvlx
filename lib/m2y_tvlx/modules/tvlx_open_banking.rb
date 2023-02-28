module M2yTvlx
  class TvlxOpenBanking
    def start_module(client_id, redirect_uri, url, state, auth)
      @client_id = client_id
      @redirect_uri = redirect_uri
      @url = url
      @state = state
      @authenticator = auth

      @authorization_code = authorization_code
    end

    def authorization_code
      authorization_code_url = "#{@url}#{BANKING_AUTH_PATH}"
      headers = {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Authorization' => "Basic #{@authenticator}"
      }
      body = URI.encode_www_form({
        grant_type: 'authorization_code', 
        code: grant_code
      })
      response = HTTParty.post(authorization_code_url, body: body, headers: headers)
      response['access_token'].present? ? response['access_token'] : ''
    end

    def grant_code
      grant_code_url = "#{@url}#{GRANT_CODE_PATH}&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}&state=#{@state}"
      response = HTTParty.get(grant_code_url, headers: { 'callback' => '0' })
      response['redirect_uri'].present? ? response['redirect_uri'].split('=')[2] : ''
    end
  end
end
