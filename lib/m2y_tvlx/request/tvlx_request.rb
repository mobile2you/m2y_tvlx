require 'httparty'

module M2yTvlx
  class TvlxRequest
    def initialize(username, password)
      @headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
      @auth = { username: username, password: password }
    end

    attr_reader :auth

    def get(url)
      url.gsub!('API/', '') unless url.include?('dev.')
      puts url.to_s
      req = HTTParty.get(url, headers: @headers, basic_auth: @auth)
      req.parsed_response
    end

    def post(url, body, headers = {})
      url.gsub!('API/', '') unless url.include?('dev.')
      puts url.to_s
      headers = @headers.merge(headers)
      req = HTTParty.post(url,
                          body: body.to_json,
                          headers: headers, basic_auth: @auth)
      puts body
      req.parsed_response
    end

    def putWithoutBody(url)
      url.gsub!('API/', '') unless url.include?('dev.')
      puts url.to_s
      req = HTTParty.put(url, headers: @headers, basic_auth: @auth)
      req.parsed_response
    end
  end
end
