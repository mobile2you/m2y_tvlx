
module M2yTvlx

	class TvlxRegistration < TvlxModule

        def initialize(access_key, secret_key, url)
            startModule(access_key, secret_key, url)
        end

        def createRegistration(body, version = 1)
            #fix cdt_params
            tvlx_body = {}
            tvlx_body[:externalIdentifier] = rand(1..9999)
            tvlx_body[:sharedAccount] = false
            tvlx_body[:client] = {
                name: body[:name],
                email: body[:email],
                socialName: body[:legalName].nil? ? body[:name] : body[:legalName],
                taxIdentifier: {
                    country: "BRA",
                    taxId: body[:document]
                },
                mobilePhone: {
                    country: "BRA",
                    phoneNumber: body[:phone][:areaCode].to_i.to_s + body[:phone][:number]
                }
            }
            puts tvlx_body

            response = @request.post(@url + ACCOUNT_PATH, tvlx_body,[tvlx_body[:externalIdentifier], tvlx_body[:client][:taxIdentifier][:taxId]].join("") )
            account = TvlxModel.new(response)
            
            if account && account.data
                account.data["registration_id"] = account.data["account"]["accountId"]
                account.data["id"] = tvlx_body[:externalIdentifier]
                account.data["account_id"] = tvlx_body[:externalIdentifier]
                account.data["person_id"] = account.data["accountHolderId"]
            end
            account
        end


	end

end
