module M2yTvlx

  class TvlxDocuments < TvlxModule

    def initialize(access_key, secret_key, url)
      startModule(access_key, secret_key, url)
    end

    def getDocumentHeaders
      url = address_url + USER_ADDRESS_PATH
      puts url
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


    def addKit(body)
      headers = getDocumentHeaders
      response = @request.post(documents_url + ADD_KIT, body, headers)
      puts response
      TvlxModel.new(response)
    end

    def checkKit(params)
      headers = getDocumentHeaders
      response = @request.post(documents_url + CHECK_KIT, params, headers)
      puts response
      TvlxModel.new(response)
    end

    def sendProposal(params)
      headers = getDocumentHeaders
      response = @request.post(documents_url + SEND_PROPOSAL, params, headers)
      puts response
      TvlxModel.new(response)
    end

    def documents_url
      @url.gsub('8090', '8091')
    end

    def address_url
      @url.gsub('8090', '8093')
    end

  end
end
