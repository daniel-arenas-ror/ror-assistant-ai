module AIService
  module OpenaiService
    class Embedding < Base
      MODEL = "text-embedding-3-small".freeze

      attr_reader :openai

      def initialize
        @openai = OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY"))
      end

      def generate_embedding(text, model: MODEL)
        response = @openai.embeddings.create(
          {
            model: model,
            input: text
          }
        )

        response.data[0].embedding
      end
    end
  end
end
