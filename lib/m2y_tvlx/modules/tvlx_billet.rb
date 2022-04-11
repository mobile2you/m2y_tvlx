module M2yTvlx

  class TvlxBillet < TvlxModule

    def initialize(access_key, secret_key, url)
      startModule(access_key, secret_key, url)
    end

    def generateTicket(tvlx_body)
      tvlx_body[:nrInst] = getInstitution
      puts tvlx_body
      url = @url + BILLETS_PATH
      puts url
      response = @request.post(url, tvlx_body)
      transferResponse = TvlxModel.new(response)
      transferResponse
    end

  end
end
