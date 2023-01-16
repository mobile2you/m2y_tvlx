module M2yTvlx
  class TvlxPixKeys < TvlxPix
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

    def create_key_claim(body)
      url = @url + PIX_CREATE_CLAIM_PATH
      headers = pix_headers
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def cancel_claim(body)
      url = @url + PIX_CANCEL_CLAIM_PATH
      headers = pix_headers
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def list_claims(params)
      url = @url + PIX_LIST_CLAIM_PATH + "?ispb=#{params[:ispb]}&limite=#{params[:limit]}"
      headers = pix_headers
      req = HTTParty.post(url, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def confirm_claim(body)
      url = @url + PIX_CONFIRM_CLAIM_PATH
      headers = pix_headers
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue StandardError
        nil
      end
    end

    def conclude_claim(body)
      url = @url + PIX_CONCLUDE_CLAIM_PATH
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
