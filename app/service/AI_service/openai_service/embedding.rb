module AIService
  module OpenaiService
    class Embedding < Base
      MODEL = "text-embedding-3-small".freeze

      attr_reader :real_estate, :openai

      def initialize(real_estate: nil)
        @real_estate = real_estate
        @openai = OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY"))
      end

      def generate_embedding(model: MODEL)
        response = @openai.embeddings.create(
          {
            model: "text-embedding-3-small",
            input: real_estate.embed_input
          }
       )

        real_estate.raw_update!(embedding: response.data[0].embedding)
      end
    end
  end
end
