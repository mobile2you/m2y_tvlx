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

  end
end
