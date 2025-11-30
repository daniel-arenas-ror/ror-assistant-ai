module AIService
  class Embedding

    attr_reader :product, :company

    def initialize(product: nil)
      @product = product
      @company = product.company
    end

    def update_embedding!
      service = "AIService::#{company.ai_source.capitalize}Service::Embedding".constantize
      array_embedding = service.new.generate_embedding(product.embed_input)

      product.raw_update!(embedding: array_embedding)
    end
  end
end
