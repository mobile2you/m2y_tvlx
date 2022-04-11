require 'json'

module M2yTvlx
  class TvlxHelper


    def self.conductorBodyToString(json)
      string = "?"
      arr = []
      json.keys.each do |key|
        if !json[key].nil?
          arr << key.to_s + "=" + json[key].to_s
        end
      end
      string + arr.join("&")
    end

    def self.generate_general_response(input)
      cdtErrorHandler = TvlxErrorHandler.new
      response = {}
      if cdtErrorHandler.mapErrorType(input)
        response = {
          success: false,
          error: cdtErrorHandler
        }
      else
        response = {
          success: true,
          content: input
        }
      end
      response
    end

    def self.saveToken(basic,token)
      if !token.nil?
        ENV["SENFF_TOKEN#{basic.last(6)}"] = token.to_s
        ENV["SENFF_TOKEN_EXPIRY#{basic.last(6)}"] = (Time.now + 1500).to_s
      end
    end

    def self.shouldRefreshToken?(basic)
      finish_date = ENV["SENFF_TOKEN_EXPIRY#{basic.last(6)}"]
      finish_date.nil? || (Time.parse(finish_date.to_s) - 500) < Time.now
    end

    def self.get_token(basic)
      ENV["SENFF_TOKEN#{basic.last(6)}"]
    end



  end
end
