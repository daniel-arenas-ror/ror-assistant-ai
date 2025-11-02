module AIService
  class ScrapeRealEstate

    attr_accessor :real_estate

    def initialize(real_estate: )
      @real_estate = real_estate
    end

    def process
      company = real_estate.company
      service = "AIService::#{company.ai_source.capitalize}Service::ScrapeRealEstate".constantize
      service.new(real_estate: real_estate).process
    end
  end
end
