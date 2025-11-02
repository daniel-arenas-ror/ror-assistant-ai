module AIService
  class ScrapeRealEstate

    attr_accessor :real_estate

    def initialize(real_estate: )
      @real_estate = real_estate
    end

    def process
      company = real_estate.company
      p " web scrapping "
      p company.ai_source
    end
  end
end
