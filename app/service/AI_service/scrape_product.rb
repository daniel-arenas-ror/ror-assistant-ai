module AIService
  class ScrapeProduct

    attr_accessor :product

    def initialize(product: )
      @product = product
    end

    def process
      company = product.company
      service = "AIService::#{company.ai_source.capitalize}Service::ScrapeProduct".constantize
      service.new(product: product).process
    end
  end
end
