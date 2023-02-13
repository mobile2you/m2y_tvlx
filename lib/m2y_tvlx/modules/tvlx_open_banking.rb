module M2yTvlx
  class TvlxOpenBanking < TvlxModule
    def initialize(client_id, redirect_uri, url, state, auth)
      @auth = banking_auth(client_id, redirect_uri, url, state, auth)
      @client_id = client_id
      @client_secret = client_secret
      @url = url
    end

    def banking_auth(client_id, redirect_uri, url, state, auth)
      grant_code = grant_code(url, client_id, redirect_uri, state)
      authorization_code(url, auth, grant_code)
    end

    def grant_code(url, client_id, redirect_uri, state)
      grant_code_url = "#{url}#{GRANT_CODE_PATH}&client_id=#{client_id}&redirect_uri=#{redirect_uri}&state=#{state}"
      response = HTTParty.post(grant_code_url,
                                 headers: {
                                   'WWW-callback' => '0'
                                 })
      param = response.parsed_response['redirect_uri'].split('=')[2]
      param.parsed_response['redirect_uri'].split('&')[0]
    end

    def authorization_code(url, auth, grant_code)
      body = {grant_type: authorization_code, code: grant_code}
      authorization_code_url = "#{url}#{BANKING_AUTH_PATH}"
      authorization_code_resp = HTTParty.post(authorization_code_url,
                                 body: body.to_json,
                                 headers: {
                                  'Content-Type' => 'application/x-www-form-urlencoded'
                                  'Authorization' => "Bearer #{auth}"
                                 })
      authorization_code_resp.parsed_response['access_token']
    end
  end
end
