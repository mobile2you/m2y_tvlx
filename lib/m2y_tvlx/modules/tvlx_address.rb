module M2yTvlx

  class TvlxAddress < TvlxModule

    def initialize(access_key, secret_key, url)
      startModule(access_key, secret_key, url)
    end



    def getAddresses(body)
      headers = getAddressHeaders
      body[:nrInst] = getInstitution
      response = @request.post(address_url + CHECK_ADDRESS, body, headers)
      puts response
      TvlxModel.new(response)
    end

  end
end
