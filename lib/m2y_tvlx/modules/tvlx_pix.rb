module M2yTvlx
  class TvlxPix < TvlxModule

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

    def pix_headers
      {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{@auth}",
        'WWW-Authenticate': @www_authenticate
      }
    end


    def get_bank(req)
      list_bank = HTTParty.get(BANKS_PIX, verify: false, headers: { 'Content-Type': 'application/json' })
      list_bank.select { |x| x['ispb'] == req['recebedor']['ispb'] }.first
    end

  end
end
