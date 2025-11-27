module AIService
  module GeminiService
    class Embedding < Base
      API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent"
      MODEL = "gemini-embedding-001"

      def generate_embedding(text, model: MODEL)
        payload = {
          model: model,
          content: { parts: [{ text: product.embed_input }] }
        }

        response = make_api_call(url, payload)
        response.dig("embedding", "values")
      end
    end
  end
end
