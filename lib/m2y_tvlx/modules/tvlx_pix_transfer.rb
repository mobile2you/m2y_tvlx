module M2yTvlx
  class TvlxPixTransfer < TvlxPix
    def receipts(from, to)
      url = @url + PIX_EXTRACT + "?dataFinalResultado=#{to}&dataInicialResultado=#{from}&horarioFinalResultado=00&horarioInicialResultado=23"
      headers = pix_headers
      puts url
      puts headers
      req = HTTParty.get(url, verify: false, headers: headers)
      req = req.parsed_response
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
      puts url
      puts req
      begin
        bank = get_bank_by_ispb(req['recebedor']['ispb'])
        req['recebedor']['bank'] = bank.present? ? bank['name'] : ''
        req['recebedor']['bank_code'] = bank.present? ? bank['code'] : ''
      rescue
      end
      
      begin
        TvlxModel.new(req)
      rescue StandardError
        nil
      end
    end

    def pix_reversal(body)
      url = @url + PIX_TRANSFER_PATH
      headers = pix_headers
      req = HTTParty.post(url, body: body.to_json, verify: false, headers: headers)
      req = req.parsed_response
      puts url
      puts req
      bank = get_bank_by_ispb(req['recebedor']['ispb'])
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

    def get_bank_by_ispb(ispb)
      bank = get_bank(ispb)
    end 

    def schedule_pix(body)
      url = @url + PIX_SCHEDULED_PATH
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
