module M2yTvlx

  class TvlxAccount < TvlxModule

    def initialize(access_key, secret_key, url)
      startModule(access_key, secret_key, url)
    end

    def getAccounts(id)
      nrinst = getInstitution
      response = @request.get(@url + ACCOUNT_PATH + "?nrCliente=#{id}&nrInst=#{nrinst}")
      p response
      account = TvlxModel.new(response["contas"].first)
      #fixing cdt_fields
      if !account.nil? && !account.cdCta.nil?
        account.saldoDisponivelGlobal = account.vlSdds
        account.idPessoa = account.cdCta
        account.idStatusConta = 0
        account.id = account.cdCta
      end
      account
    end

    def getAllAccounts(id)
      nrinst = getInstitution
      response = @request.get(@url + ACCOUNT_PATH + "?nrCliente=#{id}&nrInst=#{nrinst}")
      p response
      accounts = []
      response["contas"].each do |r|
        account = TvlxModel.new(r)
        #fixing cdt_fields
        if !account.nil? && !account.cdCta.nil?
          account.saldoDisponivelGlobal = account.vlSdds
          account.idPessoa = account.cdCta
          account.idStatusConta = 0
          account.id = account.cdCta
          accounts << account
        end
      end
      accounts
    end

    def findAccount(params)
      params[:nrSeq] = 0
      params[:nrInst] = getInstitution
      response = @request.post(@url + INDIVIDUAL_PATH, params)
      TvlxModel.new(response)
    end

    def findManager(params)
      params[:nrSeq] = 0
      params[:nrInst] = getInstitution
      response = @request.post(@url + MANAGERS_PATH, params)
      TvlxModel.new(response)
    end


    def getTransactions(params, with_future = true)
      params[:nrSeq] = 0
      params[:nrInst] = getInstitution
      if !params[:page].nil? && params[:page] > 0
        transactions = []
      else
        response = @request.post(@url + EXTRACT_PATH, params)
        transactions = response["consultaLancamento"]
      end
      # fixing cdt_fields
      if !transactions.nil?
        transactions.each do |transaction|
          transaction["dataOrigem"] = transaction["dtLanc"]
          transaction["descricaoAbreviada"] = transaction["dsLanc"] + (transaction["nmFav"].nil? ? "" : transaction["nmFav"])
          transaction["idEventoAjuste"] = transaction["idTrans"]
          transaction["codigoMCC"] = transaction["idTrans"]
          transaction["nomeFantasiaEstabelecimento"] = transaction["descricaoAbreviada"]
          transaction["valorBRL"] = transaction["vlLanc"].to_f #/100.0
          transaction["flagCredito"] = transaction["tpSinal"] == "C" ? 1 : 0
        end
      else
        transactions = []
      end

      (with_future ? getFutureTransactions(params) : [] ) + transactions
    end

    def getPaginatedTransactions(params, with_future = true)
      params[:nrSeq] = 0
      params[:nrInst] = getInstitution
      response = @request.post(@url + "#{PAGINATED_EXTRACT_PATH}?page=#{params[:page]}&size=#{params[:size]}", params)
      transactions = response["consultaLancamento"]['content']
      pages = response["consultaLancamento"]['totalPages']
      # fixing cdt_fields
      if !transactions.nil?
        transactions.each do |transaction|
          transaction["dataOrigem"] = transaction["dtLanc"]
          transaction["descricaoAbreviada"] = transaction["dsLanc"] + (transaction["nmFav"].nil? ? "" : transaction["nmFav"])
          transaction["idEventoAjuste"] = transaction["idTrans"]
          transaction["codigoMCC"] = transaction["idTrans"]
          transaction["nomeFantasiaEstabelecimento"] = transaction["descricaoAbreviada"]
          transaction["valorBRL"] = transaction["vlLanc"].to_f #/100.0
          transaction["flagCredito"] = transaction["tpSinal"] == "C" ? 1 : 0
        end
      else
        transactions = []
      end
      {
        transactions: (with_future ? getFutureTransactions(params) : [] ) + transactions,
        totalPages: pages
      }
    end

    def getFutureTransactions(params)
      params[:nrSeq] = 0
      params[:dtFin] = 20300221
      params[:nrInst] = getInstitution
      if !params[:page].nil? && params[:page] > 0
        transactions = []
      else
        begin
          response = @request.post(@url + FUTURE_EXTRACT_PATH, params)
          transactions = response["listaLancFuturos"]
        rescue
          transactions = []
        end
      end

      # fixing cdt_fields
      if !transactions.nil?
        transactions.each do |transaction|
          transaction["dataOrigem"] = transaction["dtLancft"]
          transaction["descricaoAbreviada"] = transaction["dsHist"] + (transaction["nmFav"].nil? ? "" : transaction["nmFav"])
          transaction["idEventoAjuste"] = transaction["idTrans"]
          transaction["codigoMCC"] = transaction["idMovto"]
          transaction["nomeFantasiaEstabelecimento"] = transaction["descricaoAbreviada"]
          transaction["valorBRL"] = transaction["vlLanc"].to_f #/100.0
          transaction["flagCredito"] = transaction["tpSinal"] == "C" ? 1 : 0
        end
      else
        transactions = []
      end
      transactions
    end

  end
end
