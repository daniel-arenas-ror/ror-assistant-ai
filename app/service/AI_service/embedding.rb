module AIService
  class Embedding < Base

    attr_reader :product, :company

    def initialize(product: nil)
      @product = product
      @company = product.company
    end

    def update_embedding!
      service = "AIService::#{company.ai_source.capitalize}Service::#{class.name}".constantize
      array_embedding = service.generate_embedding

      product.raw_update!(embedding: array_embedding)
    end
  end
end
