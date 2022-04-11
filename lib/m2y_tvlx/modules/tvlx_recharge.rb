module M2yTvlx

  class TvlxRecharge < TvlxModule

    def initialize(client_id, client_secret, url, scope, auth_url)
      @auth = TvlxAuth.new(client_id, client_secret, url)
      @client_id = client_id
      @client_secret = client_secret
      @url = url
      @auth = TvlxAuth.new(client_id, client_secret, auth_url + RECHARGE_AUTH_PATH, scope)
    end

    def dealers
      refreshToken
      headers = json_headers
      headers["Authorization"] = "Bearer #{TvlxHelper.get_token(@client_secret)}"

      url = @url + DEALERS_PATH
      puts url
      puts headers.to_json
      req = HTTParty.get(url, :verify => false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue
        nil
      end
    end

    def refreshToken
      if TvlxHelper.shouldRefreshToken?(@client_secret)
        @auth.generateToken
      end
    end


    def receipts(account, from, to)
      refreshToken
      headers = json_headers
      headers["Authorization"] = "Bearer #{TvlxHelper.get_token(@client_secret)}"

      url = @url + RECHARGES_RECEIPTS + "?conta=#{account}&dataInicial=#{from}&dataFinal=#{to}"
      req = HTTParty.get(url, :verify => false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue
        nil
      end
    end

    def packages(body)
      refreshToken
      headers = json_headers
      headers["Authorization"] = "Bearer #{TvlxHelper.get_token(@client_secret)}"

      url = @url + RECHARGES_PACKAGES
      puts url
      req = HTTParty.post(url, body: body.to_json, :verify => false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue
        nil
      end
    end

    def recharge(body)
      refreshToken
      headers = json_headers
      headers["Authorization"] = "Bearer #{TvlxHelper.get_token(@client_secret)}"

      url = @url + RECHARGE
      puts url
      req = HTTParty.post(url, body: body.to_json, :verify => false, headers: headers)
      begin
        TvlxModel.new(req.parsed_response)
      rescue
        nil
      end
    end


  end

end
