module AIService
  module GeminiService
    class Base
      GEMINI_API_KEY = ENV.fetch('GEMINI_API_KEY', '') 
      API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-09-2025:generateContent?key=#{GEMINI_API_KEY}"

    
      def make_api_call(history, system_instruction, tool_spec, max_retries = 3)
        uri = URI.parse(API_URL)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        payload = {
          "contents" => history,
          "systemInstruction" => { "parts" => [{ "text" => system_instruction }] },
          "tools" => [tool_spec]
        }.to_json

        headers = { 'Content-Type' => 'application/json' }
        
        (1..max_retries).each do |attempt|
          request = Net::HTTP::Post.new(uri.request_uri, headers)
          request.body = payload

          response = http.request(request)
          
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
    end
  end
end
