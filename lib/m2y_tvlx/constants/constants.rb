module M2yTvlx
  # banks
  BANK_ID = 1309
  INSTITUTION_ID = 1309

  # pix
  SCOPE = 'qrcode_api'
  GRANT_TYPE = 'client_credentials'
  PIX_AUTH_PATH = '/api/sq-orchest-auth/auth/login'
  PIX_CREATE_KEY_PATH = '/api/sq-orchest-starter/start/dict/chaves'
  PIX_REMOVE_KEY_PATH = '/api/sq-orchest-starter/start/dict/chaves'
  PIX_LIST_KEYS_PATH = '/api/sq-orchest-starter/start/legado/chaves/listar'
  PIX_TRANSFER_PATH = '/api/sq-orchest-starter/start/spi/pagamentos'
  PIX_REVERSAL_PATH = '/api/sq-orchest-starter/start/spi/devolucoes'
  PIX_FIND_KEY = '/api/sq-orchest-starter/start/dict/chaves'
  PIX_CREATE_QR_STATIC = '/api/sq-orchest-starter/start/qrcode/v2/static'
  PIX_DECODE_QR = '/api/sq-orchest-starter/start/qrcode/v2/decode'
  PIX_EXTRACT = '/api/sq-orchest-starter/start/spi/extrato'
  PIX_CREATE_CLAIM_PATH = '/api/sq-orchest-starter/start/dict/reivindicacoes'
  PIX_CANCEL_CLAIM_PATH = '/api/sq-orchest-starter/start/dict/reivindicacoes/cancela'
  PIX_LIST_CLAIM_PATH = '/api/sq-orchest-starter/start/dict/reivindicacoes'
  PIX_CONFIRM_CLAIM_PATH = '/api/sq-orchest-starter/start/dict/reivindicacoes/confirma'
  PIX_CONCLUDE_CLAIM_PATH = '/api/sq-orchest-starter/start/dict/reivindicacoes/conclui'
  BANKS_PIX = 'https://brasilapi.com.br/api/banks/v1'
  ### Paths

  # account
  DEPOSIT_PATH = 'v1/accounts/deposits'
  PAYMENT_PATH = 'v1/payments'

  STATEMENT = '/statement'
  WITHDRAW = '/withdraw'

  BANKS_PATH = '/API/BJ08M01/BJ08SS0102A1/listarBancos'
  ACCOUNT_PATH = '/API/BJ08M01/BJ08SS0102M/obterContas'
  MANAGERS_PATH = '/API/BJ08M01/BJ08SS0101E/consultaGerente'

  USER_PATH = '/API/user'
  INDIVIDUAL_PATH = '/API/BJ08M01/BJ08SS0101L/buscaDadosCliente'
  CUSTOMERS_PATH = '/API/BJ08M01/BJ08SS0107A/obterClientes'
  EXTRACT_PATH = '/API/BJ08M01/BJ08SS0101C/listaLancamentos'
  PAGINATED_EXTRACT_PATH = '/API//BJ08M01/BJ08SS0101C/listaLancamentosPaginados'
  FUTURE_EXTRACT_PATH = '/API/BJ08M01/BJ08SS0101F/listaLancFuturos'
  RECEIPTS_PATH = '/API/BJ08M01/BJ08SS0101M/obterComprovantes'
  FIND_RECEIPTS_PATH = '/API/BJ08M01/BJ08SS0101N/criarComprovante'
  TRANSFER_PATH = '/API/BJ08M01/BJ08SS0101K/efetuaLancamentoTransferencia'
  ADD_FAV_PATH = '/API/BJ08M01/BJ08SS0102O/manutencaoCadastrarFavorecido'
  REMOVE_FAV_PATH = '/API/BJ08M01/BJ08SS0102O/manutencaoExcluirFavorecido'
  CHECK_FAV_PATH = '/API/BJ08M01/BJ08SS0102O/manutencaoListarFavorecidos'
  RECEIPTS_DETAILS = '/API/BJ08M01/BJ08SS0101O/consultaComprovanteDetalhados'
  CANCEL_TRANSFER_PATH = '/API/BJ08M01/BJ08SS0103D/cancelarAgendamento'

  # BILLETTS
  BILLETS_PATH = '/API/BJ08M01/BJ08SS0102G/gerarBoleto'

  # PAYMENTS
  VALIDATE_EAN = '/API/BJ08M01/BJ08SS0102F/validarBoleto'
  PAY_EAN = '/API/BJ08M01/BJ08SS0102E/pagarBoleto'

  # DEG
  ADD_KIT = '/BJ79M02/BJ79M02/BJ79SS0101B/kitdoc'
  CHECK_KIT = '/BJ79M02/BJ79M02/BJ79SS0101B/consultaKit'
  SEND_PROPOSAL = '/BJ79M02/BJ79M02/BJ79SS0101A/proposta'

  CHECK_ADDRESS = '/BJ01M06/clientesEndereco/pesquisa'
  CHECK_CUSTOMERS = '/BJ01M06/clientes/pesquisa'
  USER_ADDRESS_PATH = '/BJ01M06/user'

  # recharge
  RECHARGE_AUTH_PATH = '/connect/token'
  DEALERS_PATH = '/api/mobile-rechange/operator'
  RECHARGES_RECEIPTS = '/api/cellphone-topups'
  RECHARGES_PACKAGES = '/api/mobile-rechange/refill-request'
  RECHARGE = '/api/mobile-rechange/request-recharge/pj'

  # payments
  PAYMENT_AUTH_PATH = '/connect/token'
  VALIDATE_PATH = '/api/bill-payments/'
  PAYMENTS_RECEIPTS = '/api/payments'
  PAY = '/api/bill-payments/pj'

  # open banking
  GRANT_CODE_PATH = '/oauth/v1/grant-code?response_type=code'
  BANKING_AUTH_PATH = '/oauth/v1/access-token'

  #open banking phase 3
  
  #open banking phase 3 - ITP Initiator
  FIND_ORGANIZATION = '/open-banking/journey-tpp/v1/authorisationservers'
  CONSENTS_PATH_ITP = '/open-banking/journey-tpp/v1/payments/consents'
  
  #open banking phase 3 - ID Holder
  CONSENTS_PATH = '/open-banking/journey-aspsp/v1/payments/consents/'
end
