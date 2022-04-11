module M2yTvlx

	class TvlxAuth 

      def initialize(client_id, client_secret, url, scope = nil)
        @client_id = client_id
        @client_secret = client_secret
        @url = url
        @scope = scope
      end

      def generateToken
        puts @url
        data = {
          client_id: @client_id,
          client_secret: @client_secret,
          grant_type: GRANT_TYPE,
          scope: @scope.nil? ? SCOPE : @scope,
        }

        puts data.to_json
        puts data.to_json

        if !@url.include?("connect")
          @url += PIX_AUTH_PATH
        end

        puts @url
        body = URI.encode_www_form(data)
        puts body.to_s
        response = HTTParty.post(@url,
          body: body,
          headers: { 
            'Content-Type' => 'application/x-www-form-urlencoded'
          }, :verify => false
        )

        puts response.to_json

        if response.code == 200
          TvlxHelper.saveToken(@client_secret, response.parsed_response["access_token"])
        end
	   end

	end
end


