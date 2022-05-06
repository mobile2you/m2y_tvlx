module M2yTvlx

  class TvlxTransfer < TvlxModule

    def initialize(access_key, secret_key, url)
      startModule(access_key, secret_key, url)
    end


    def getFavorites(body)
      tvlx_body = body
      tvlx_body[:tpFiltro] = 1
      response = @request.post(@url + CHECK_FAV_PATH, tvlx_body)
      puts response
      if response["listaFavorecidos"].nil?
        []
      else
        response["listaFavorecidos"]
      end
    end


    def bankTransfers(body, is_ted, date = nil)
      # if !checkFav(body)
        addFav(body)
      # end

      #fix cdt_params
      tvlx_body = {}
      tvlx_body[:idTitul] = 'C'

      tvlx_body[:cdCta] = body[:cdCta]
      tvlx_body[:cdFin] = body[:cdFin]
      tvlx_body[:nrAgen] = body[:nrAgen]
      tvlx_body[:vlLanc] = body[:value]

      # if Time.now.utc.hour > 20
      #   date = DateTime.now.next_day
      # else
      if date.nil?
        date = DateTime.now
      end

      if date.hour > 20
        date = DateTime.now.next_day
      end


      if date.wday == 6
        date = date.next_day.next_day
      elsif date.wday == 0
        date = date.next_day
      end

      tvlx_body[:dtLanc] = date.strftime("%Y%m%d")
      tvlx_body[:tpTransf] = is_ted ? 2 : 3
      tvlx_body[:tpCtaFav] = 'CC'
      tvlx_body[:nrSeqDes] = 0
      tvlx_body[:cdOrigem] = 24556
      tvlx_body[:nrDocCre] = 9
      tvlx_body[:cdFin] = 30
      tvlx_body[:nrSeq] = 0
      tvlx_body[:dsHist] = ''
      tvlx_body[:dsHistC] = ''
      tvlx_body[:nrBcoDes] = body[:beneficiary][:bankId]
      tvlx_body[:nrCpfCnpj] = body[:beneficiary][:docIdCpfCnpjEinSSN]
      tvlx_body[:nrAgeDes] = body[:beneficiary][:agency]
      tvlx_body[:nrCtaDes] = body[:beneficiary][:account]

      #adicionando DV
      if !body[:beneficiary][:accountDigit].nil?
        tvlx_body[:nrCtaDes] = "#{tvlx_body[:nrCtaDes]}#{body[:beneficiary][:accountDigit]}".to_i
      end


      tvlx_body[:nmFavore] = body[:beneficiary][:name]
      tvlx_body[:nrInst] = getInstitution

      puts tvlx_body

      response = @request.post(@url + TRANSFER_PATH, tvlx_body)

      puts response
      transferResponse = TvlxModel.new(response)

      if transferResponse && transferResponse.efetuaLancamentoTransferencia == 0
        transferResponse.id = Time.now.to_i
        transferResponse.statusCode = 200
        transferResponse.transactionCode = Time.now.to_i
        # transferResponse.content = transferResponse
      end
      transferResponse
    end


    def getBankTransfers(params)
      params[:nrSeq] = 0
      params[:nrInst] = getInstitution
      params[:tpComprovante] = 1
      response = @request.post(@url + RECEIPTS_PATH, params)
      TvlxModel.new(response)
    end

    def getBankTransfersDetails(params)
      params[:nrSeq] = 0
      params[:nrInst] = getInstitution
      puts @url + RECEIPTS_DETAILS
      puts params
      response = @request.post(@url + RECEIPTS_DETAILS, params)
      TvlxModel.new(response)
    end

    def findReceipt(params)
      params[:nrSeq] = 0
      params[:nrInst] = getInstitution
      response = @request.post(@url + FIND_RECEIPTS_PATH, params)
      TvlxModel.new(response)
    end

  end
end
