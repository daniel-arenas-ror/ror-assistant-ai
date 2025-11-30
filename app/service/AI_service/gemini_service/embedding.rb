module AIService
  module GeminiService
    class Embedding < Base
      API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent"
      MODEL = "gemini-embedding-001"

      def initialize
        super(ENV.fetch('GEMINI_API_KEY', ''))
      end

      def generate_embedding(text, model: MODEL)
        payload = {
          model: model,
          content: { parts: [{ text: text }] }
        }

        response = make_api_call(url: API_URL, payload: payload)
        response.dig("embedding", "values")
      end
    end
  end
end
