module AIService
  module GrokService
    class Embedding < Base
      API_URL = "https://api.x.ai/v1/tokenize-text"
      MODEL = "grok-4-0709"

      def initialize
        super(ENV.fetch('GROK_API_KEY', ''))
      end

      def generate_embedding(text, model: MODEL)
        payload = {
          model: model,
          text: text
        }

        response = make_api_call(url: API_URL, payload: payload)
        response.dig("data", 0, "embedding")
      end
    end
  end
end
