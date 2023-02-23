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
      url = "#{@url}#{CONSENTS_PATH}#{consent_id}"
      headers = {
        'Authorization' => "Bearer #{@authorization_code}"
      }
      response = HTTParty.get(url, headers: headers)
      response["errors"].blank? ? response["data"] : response.parsed_response
    end

    def confirm_agreement(consent_id) #3-Authorize Confirmation
      url = "#{@url}#{CONSENTS_PATH}#{consent_id}/authorised"
      headers = {
        'Authorization' => "Bearer #{@authorization_code}"
      }
      response = HTTParty.patch(url, headers: headers, follow_redirects: false)
      response.parsed_response
    end 

    def refuse_agreement(consent_id) #3-Reject Confirmation
      url = "#{@url}#{CONSENTS_PATH}#{consent_id}/rejected"
      headers = {
        'Authorization' => "Bearer #{@authorization_code}"
      }
      response = HTTParty.patch(url, headers: headers, follow_redirects: false)
      response.parsed_response
    end 
  end
end