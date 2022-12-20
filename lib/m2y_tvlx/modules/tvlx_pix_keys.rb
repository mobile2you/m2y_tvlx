module M2yTvlx
  class TvlxPixKeys < TvlxModule
    def initialize(client_id, client_secret, url, www_authenticate)
      @www_authenticate = www_authenticate
      @auth = pix_auth(client_id, client_secret, url + PIX_AUTH_PATH)
      @client_id = client_id
      @client_secret = client_secret
      @url = url
    end

    def refreshToken
      @auth.generateToken if TvlxHelper.shouldRefreshToken?(@client_secret)
    end

    def list_keys(body)
      url = @url + PIX_LIST_KEYS_PATH
      headers = json_headers
      headers['Authorization'] = "Bearer #{@auth}"
      headers['WWW-Authenticate'] = @www_authenticate
      headers['Content-Type'] = 'application/json'
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def create_key(body)
      url = @url + PIX_CREATE_KEY_PATH
      headers = json_headers
      headers['Authorization'] = "Bearer #{@auth}"
      headers['WWW-Authenticate'] = @www_authenticate
      headers['Content-Type'] = 'application/json'
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def remove_key(key)
      url = @url + PIX_REMOVE_KEY_PATH + "/#{key}/USER_REQUESTED"
      headers = json_headers
      headers['Authorization'] = "Bearer #{@auth}"
      headers['WWW-Authenticate'] = @www_authenticate
      headers['Content-Type'] = 'application/json'
      req = HTTParty.delete(url, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def find_key(key, id)
      url = @url + PIX_FIND_KEY + "/#{key}/#{id}"
      headers = json_headers
      headers['Authorization'] = "Bearer #{@auth}"
      headers['WWW-Authenticate'] = @www_authenticate
      headers['Content-Type'] = 'application/json'
      req = HTTParty.get(url, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def pix_transfer(body)
      url = @url + PIX_TRANSFER_PATH
      headers = json_headers
      headers['Authorization'] = "Bearer #{@auth}"
      headers['WWW-Authenticate'] = @www_authenticate
      headers['Content-Type'] = 'application/json'
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def pix_auth(client_id, client_secret, url)
      auth = { username: client_id, password: client_secret }
      response = HTTParty.post(url,
                               body: auth,
                               headers: {
                                 'WWW-Authenticate' => @www_authenticate,
                                 'Content-Type' => 'application/x-www-form-urlencoded'
                               }, basic_auth: auth)

      response.parsed_response['access_token']
    end
  end
end
