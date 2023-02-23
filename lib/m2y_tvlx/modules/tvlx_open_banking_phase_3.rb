module M2yTvlx
  class TvlxOpenBankingPhase3 < TvlxOpenBanking
    def initialize(client_id, redirect_uri, url, state, auth)
      start_module(client_id, redirect_uri, url, state, auth)
    end

    #ID Step
    def find_agreement(consent_id) #2-Find agreement by id
      url = "#{@url}#{CONSENTS_PATH}#{consent_id}"
      headers = {
        'Authorization' => "Bearer #{@authorization_code}"
      }
      response = HTTParty.get(url, headers: headers)
      response["errors"].blank? ? response["data"] : response.parsed_response
    end

    def confirm_agreement(consent_id)
      url = "#{@url}#{CONSENTS_PATH}#{consent_id}/authorised"
      headers = {
        'Authorization' => "Bearer #{@authorization_code}"
      }
      response = HTTParty.get(url, headers: headers)
      response.parsed_response
    end 

    def refuse_agreement(consent_id)
      url = "#{@url}#{CONSENTS_PATH}#{consent_id}/rejected"
      headers = {
        'Authorization' => "Bearer #{@authorization_code}"
      }
      response = HTTParty.get(url, headers: headers)
      response.parsed_response
    end 
  end
end