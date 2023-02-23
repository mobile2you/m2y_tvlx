module M2yTvlx
  class TvlxOpenBankingPhase3 < TvlxOpenBanking
    def initialize(client_id, redirect_uri, url, state, auth)
      start_module(client_id, redirect_uri, url, state, auth)
    end

    #ITP Initiator Step
    def find_organization(options={}) #2-Find a banking organization
      url = "#{@url}#{FIND_ORGANIZATION}"
      headers = {
        'Authorization' => "Bearer #{@authorization_code}"
      }
      query = {}
      query[:organisationName] = options[:organization_name] if options[:organization_name].present?
      query[:role] = options[:role] if options[:role].present?
      response = HTTParty.get(url, headers: headers, query: query)
      response.parsed_response
    end

    #ID Holder Step
    def find_agreement(consent_id) #2-Find agreement by id
      url = "#{@url}#{FIND_AGREEMENT}#{consent_id}"
      headers = {
        'Authorization' => "Bearer #{@authorization_code}"
      }
      response = HTTParty.get(url, headers: headers)
      response["errors"].blank? ? response["data"] : response.parsed_response
    end
  end
end