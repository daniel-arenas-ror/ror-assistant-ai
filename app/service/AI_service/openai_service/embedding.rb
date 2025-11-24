module AIService
  module OpenaiService
    class Embedding < Base
      MODEL = "text-embedding-3-small".freeze

      attr_reader :product, :openai

      def initialize(product: nil)
        @product = product
        @openai = OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY"))
      end

      def generate_embedding(model: MODEL)
        response = @openai.embeddings.create(
          {
            model: "text-embedding-3-small",
            input: product.embed_input
          }
       )

        product.raw_update!(embedding: response.data[0].embedding)
      end
    end
  end
end
