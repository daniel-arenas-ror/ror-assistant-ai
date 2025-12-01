module AIService
  class Embedding

    attr_reader :product, :company

    def initialize(product: nil, company: nil)
      @product = product
      @company = company || product.company
    end

    def generate_embedding(text: "")
      service = "AIService::#{company.ai_source.capitalize}Service::Embedding".constantize
      service.new.generate_embedding(text)
    end

    def update_embedding!
      product.raw_update!(embedding: generate_embedding(text: product.embed_input))
    end
  end
end
