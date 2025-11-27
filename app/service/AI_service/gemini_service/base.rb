module AIService
  module GeminiService
    class Base
      GEMINI_API_KEY = ENV.fetch('GEMINI_API_KEY', '')
      API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

    
      def make_api_call(history, system_instruction, tool_spec, max_retries = 3)

        payload = {
          contents: history,
          system_instruction: { parts: [{ text: system_instruction }] },
          #tools: [tool_spec]
        }.to_json


        (1..max_retries).each do |attempt|
          response = HTTParty.post(API_URL, body: payload.to_json, headers: headers)
          
          if response.code == '200'
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
          'x-goog-api-key' => GEMINI_API_KEY
        }
      end
    end
  end
end
