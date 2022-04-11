module M2yTvlx

  class TvlxIndividual < TvlxModule

    def initialize(access_key, secret_key, url)
      startModule(access_key, secret_key, url)
    end

    def findPerson(cpf)
      response = @request.get(@url + CUSTOMERS_PATH + "?nrCpfcnpjUsu=#{cpf}")
      begin
        TvlxModel.new(response["clientes"].select{|x| x["nrCpfCnpjCli"] == cpf}.first)
      rescue
        nil
      end
    end


    def searchCustomers(body)
      headers = getAddressHeaders
      body[:nrInst] = getInstitution
      response = @request.post(address_url + CHECK_CUSTOMERS, body, headers)
      puts response
      TvlxModel.new(response)
    end

  end

end
