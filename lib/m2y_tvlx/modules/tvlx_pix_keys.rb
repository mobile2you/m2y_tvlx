module M2yTvlx
  class TvlxPixKeys < TvlxModule
    def initialize(client_id, client_secret, url)
      @auth = pix_auth(client_id, client_secret, url + PIX_AUTH_PATH)
      @client_id = client_id
      @client_secret = client_secret
      @url = url
    end

    def refreshToken
      @auth.generateToken if TvlxHelper.shouldRefreshToken?(@client_secret)
    end

    def list_keys(body)
      refreshToken
      url = @url + PIX_LIST_KEYS_PATH
      headers = json_headers
      headers['Authorization'] = "Bearer #{TvlxHelper.get_token(@client_secret)}"
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def create_key(body)
      url = @url + PIX_CREATE_KEY_PATH
      puts url
      headers = json_headers
      headers['Authorization'] = @auth
      headers['WWW-Authenticate'] = WWW_AUTHENTICATE
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      puts req
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def remove_key(id, body)
      refreshToken
      url = @url + PIX_REMOVE_KEY_PATH + id.to_s
      puts url
      headers = json_headers
      headers['Authorization'] = "Bearer #{TvlxHelper.get_token(@client_secret)}"
      headers['Chave-Idempotencia'] = SecureRandom.uuid
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def pix_auth(_client_id, _client_secret, url)
      auth = { username: 'test', password: 'test' }

      body = URI.encode_www_form(auth)

      response = HTTParty.post(url,
                               body: auth,
                               headers: {
                                 'WWW-Authenticate' => WWW_AUTHENTICATE,
                                 'Content-Type' => 'application/x-www-form-urlencoded'
                               }, basic_auth: auth)

      puts response
      [response, body, auth, url]
    end
  end
end
