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
      headers = pix_headers
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def create_key(body)
      url = @url + PIX_CREATE_KEY_PATH
      headers = pix_headers
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def remove_key(key)
      url = @url + PIX_REMOVE_KEY_PATH + "/#{key}/USER_REQUESTED"
      headers = pix_headers
      req = HTTParty.delete(url, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def find_key(key, id)
      url = @url + PIX_FIND_KEY + "/#{key}/#{id}"
      headers = pix_headers
      req = HTTParty.get(url, verify: false, headers: headers)
      req = req.parsed_response
      bank = get_bank(req)
      req['chave']['dadosConta']['bank'] = bank.present? ? bank['name'] : ''
      req['chave']['dadosConta']['bank_code'] = bank.present? ? bank['code'] : ''
      begin
        TvlxModel.new(req)
      rescue StandardError
        nil
      end
    end

    def pix_transfer(body)
      url = @url + PIX_TRANSFER_PATH
      headers = pix_headers
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      req = req.parsed_response
      bank = get_bank(req)
      req['recebedor']['bank'] = bank.present? ? bank['name'] : ''
      req['recebedor']['bank_code'] = bank.present? ? bank['code'] : ''
      begin
        TvlxModel.new(req)
      rescue StandardError
        nil
      end
    end

    def generate_qr_static(body)
      url = @url + PIX_CREATE_QR_STATIC
      headers = pix_headers
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def decode_qr(body)
      url = @url + PIX_DECODE_QR
      headers = pix_headers
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

    def pix_headers
      {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{@auth}",
        'WWW-Authenticate': @www_authenticate
      }
    end

    private

    def get_bank(req)
      list_bank = HTTParty.get(BANKS_PIX, verify: false, headers: { 'Content-Type': 'application/json' })
      list_bank.select { |x| x['ispb'] == req['recebedor']['ispb'] }.first
    end
  end
end
