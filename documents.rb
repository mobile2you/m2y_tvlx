require "m2y_tvlx"

basic_user = "ws.mobile2you"
basic_password = "z1x2c3v$B%N&"
basic_user = "ws_mby"
basic_password = "M%%HLI#0"
env = "prd"
cpf = "37856994843"

a = M2yTvlx::TvlxDocuments.new(basic_user, basic_password, url)


# cdt_params = {
#   "descricaoKit": "KIT FFA",
#   "idSituacao": 1,
#   "dataInicioVigencia": 20191023,
#   "dataFimVigencia": 20301025,
#   "listaDocumentos": [
#     { "codigoTpDocumento": 500, "idObrigatoriedade": 2 }, #rg_frente
#     { "codigoTpDocumento": 515, "idObrigatoriedade": 2 }, #rg_verso
#     { "codigoTpDocumento": 530, "idObrigatoriedade": 1 } #selfie
#   ]
# }

# #usar kit 1

# p a.addKit(cdt_params)


cdt_params = {
  "nrKit": 1
}

#usar kit 1

# p a.checkKit(cdt_params)


cdt_params = {
  "numeroProposta": 123,
  "codigoKit": 1,
  "codigoOperacao": 1,
  "codigoProduto": 1,
  "cpfCnpj": 37856994843,
  "listaDocumentos": [
    { "codigoDocumento": 500, "nomeArquivo": "cpf.jpg", "imagemBase64": "blabla" }, #rg_frente
    { "codigoDocumento": 504, "nomeArquivo": "selfie.jpg", "imagemBase64": "blabla" }, #rg_frente
    { "codigoDocumento": 500, "nomeArquivo": "verso.jpg", "imagemBase64": "blabla" } #rg_frente
  ]
}

#usar kit 1

p a.sendProposal(cdt_params)


