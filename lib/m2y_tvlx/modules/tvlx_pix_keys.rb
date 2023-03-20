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

    def check_key(key, id)
      url = @url + PIX_FIND_KEY + "/#{key}/#{id}"
      headers = pix_headers
      puts url
      puts headers
      req = HTTParty.get(url, verify: false, headers: headers)
      response = req.parsed_response
      puts req
      if req.code <= 202
        bank = get_bank(response['chave']['dadosConta']['ispb'])
        puts bank
        response['chave']['dadosConta']['bank'] = bank.present? ? bank['name'] : ''
        response['chave']['dadosConta']['bank_code'] = bank.present? ? bank['code'] : ''
      end
      begin
        TvlxModel.new(response)
      rescue StandardError
        nil
      end
    end

    def find_key(key, id)
      url = @url + PIX_FIND_KEY + "/#{key}/#{id}"
      headers = pix_headers
      req = HTTParty.get(url, verify: false, headers: headers)
      req = req.parsed_response
      if req['chave'].present?
        bank = get_bank(req['chave']['dadosConta']['ispb'])
        req['chave']['dadosConta']['bank'] = bank.present? ? bank['name'] : ''
        req['chave']['dadosConta']['bank_code'] = bank.present? ? bank['code'] : ''
      end
      
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
      url = @url + PIX_LIST_CLAIM_PATH + "?ispb=#{params[:ispb]}&limite=#{params[:limit]}&reivindicador=true"
      headers = pix_headers
      req = HTTParty.get(url, verify: false, headers: headers)
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
  end
end
