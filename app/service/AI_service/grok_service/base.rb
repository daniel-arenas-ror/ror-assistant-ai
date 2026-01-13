module AIService
  module GrokService
    class Base

      attr_reader :grok_api_key

      def initialize(grok_api_key)
        @grok_api_key = grok_api_key
      end

      def make_api_call(url: API_URL, payload: {}, method: :post)
        max_retries = 3

        (1..max_retries).each do |attempt|
          response = HTTParty.send(method, url, body: payload.to_json, headers: headers)

          if response.code == 200
            return JSON.parse(response.body)
          elsif response.code.to_i >= 500 || (response.code.to_i == 429 && attempt < max_retries)
            # 5xx errors or 429 (Rate Limit) trigger backoff
            sleep(2 ** attempt)
            next
          else
            raise "API Error: #{response.code} - #{response.body}"
          end
        end

        raise "API request failed after #{max_retries} attempts."
      end

      def headers
        { 
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{grok_api_key}"
        }
      end
    end
  end
end
