module M2yTvlx

  class TvlxModule

    def startModule(access_key, secret_key, url)
      @request = TvlxRequest.new(access_key, secret_key)
      @url = url
    end

    def generateResponse(input)
      TvlxHelper.generate_general_response(input)
    end

    def getInstitution
      # response = @request.get(@url + USER_PATH)
      # TvlxModel.new(response).nrInst
      INSTITUTION_ID
    end

    def json_headers
      {"Content-Type": "application/json"}
    end


    def tvlxBody(body, with_digit = false)
      tvlx_body = {}
      tvlx_body[:cdCta] = body[:cdCta]
      tvlx_body[:nrAgen] = body[:nrAgen]
      tvlx_body[:tpCtaptb] = 'CC'
      tvlx_body[:nrSeqDes] = 0
      tvlx_body[:nrSeq] = 0
      tvlx_body[:nrBanco] = body[:beneficiary][:bankId]
      tvlx_body[:nrCpfcnpj] = body[:beneficiary][:docIdCpfCnpjEinSSN]
      tvlx_body[:nrAgedes] = body[:beneficiary][:agency]
      tvlx_body[:cdCtades] = body[:beneficiary][:account]
      if !body[:beneficiary][:accountDigit].nil? && with_digit
        tvlx_body[:cdCtades] = "#{tvlx_body[:cdCtades]}#{body[:beneficiary][:accountDigit]}".to_i
      end
      tvlx_body[:nmFav] = body[:beneficiary][:name]
      tvlx_body[:nmApel] = body[:beneficiary][:name]
      tvlx_body[:dsPesq] = body[:beneficiary][:name]
      tvlx_body[:nrInst] = getInstitution
      tvlx_body
    end

    def addFav(body)
      # tvlx_body = tvlxBody(body, false)
      # response = @request.post(@url + ADD_FAV_PATH, tvlx_body)
      tvlx_body = tvlxBody(body, true)
      response = @request.post(@url + ADD_FAV_PATH, tvlx_body)
      puts response
    end

    def checkFav(body)
      tvlx_body = tvlxBody(body)
      tvlx_body[:tpFiltro] = 1
      response = @request.post(@url + CHECK_FAV_PATH, tvlx_body)
      puts response
      if response["listaFavorecidos"].nil?
        false
      else
        response["listaFavorecidos"].each do |fav|
          if fav["cdCtades"] == tvlx_body[:cdCtades]
            return true
          end
        end
        false
      end
      #dev only
      false
    end

    def getAddressHeaders
      url = address_url + USER_ADDRESS_PATH
      response = HTTParty.get(url, basic_auth: @request.auth)

      headers = {}

      token = response.headers["set-cookie"]
      if !token.nil?
        token = token.split("XSRF-TOKEN=").last.split(";").first
        puts token
        headers["X-XSRF-TOKEN"] = token
        headers["Cookie"] = "XSRF-TOKEN=#{token}"
      end
      puts headers
      headers
    end

    def address_url
      @url.gsub('8090', '8093')
    end

  end

end
