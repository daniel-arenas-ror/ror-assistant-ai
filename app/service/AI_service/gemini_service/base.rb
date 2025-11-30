module AIService
  module GeminiService
    class Base

      attr_reader :gemini_api_key

      def initialize(gemini_api_key)
        @gemini_api_key = gemini_api_key
      end

      def make_api_call(url: API_URL, payload: {})
        max_retries = 3

        (1..max_retries).each do |attempt|
          response = HTTParty.post(url, body: payload.to_json, headers: headers)

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
          'x-goog-api-key' => gemini_api_key
        }
      end
    end
  end
end
