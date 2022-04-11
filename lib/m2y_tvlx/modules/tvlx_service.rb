module M2yTvlx

  class TvlxService < TvlxModule

    def initialize(access_key, secret_key, url)
      startModule(access_key, secret_key, url)
    end

    def p2pTransfer(body)
      if !checkFav(body)
        addFav(body)
      end

      #fix cdt_params
      tvlx_body = {}
      tvlx_body[:idTitul] = 'C'

      tvlx_body[:cdCta] = body[:cdCta]
      tvlx_body[:nrAgen] = body[:nrAgen]
      tvlx_body[:vlLanc] = body[:value]
      tvlx_body[:dtLanc] = Time.now.strftime("%Y%m%d")
      tvlx_body[:tpTransf] = 1
      tvlx_body[:tpCtaFav] = 'CC'
      tvlx_body[:nrSeqDes] = 0
      tvlx_body[:cdOrigem] = 24556
      tvlx_body[:nrDocCre] = 9
      tvlx_body[:cdFin] = 30
      tvlx_body[:nrSeq] = 0
      tvlx_body[:dsHist] = ''
      tvlx_body[:dsHistC] = ''
      tvlx_body[:nrBcoDes] = get_bank
      tvlx_body[:nrCpfCnpj] = body[:beneficiary][:docIdCpfCnpjEinSSN]
      tvlx_body[:nrAgeDes] = 1
      tvlx_body[:nrCtaDes] = body[:beneficiary][:account]
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


    def get_bank
      BANK_ID
    end

  end
end
