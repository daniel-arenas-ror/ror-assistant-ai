module AIService
  module GeminiService
    class ScrapeProduct < Base
      attr_accessor :product, :assistant
      attr_reader :document, :headers_scrapping

      API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

      def initialize(product:)
        super(ENV.fetch('GEMINI_API_KEY', ''))

        @product = product
        @assistant = product.company.assistant
        @headers_scrapping = {
          "user-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
        }
      end

      def process
        url = product.url
        product_text = extract_text_from_url(url)

        url_images = product_text.css('img').map { |img| img['src'] }.compact.uniq
        product_text = product_text.text.gsub(/\s+/, " ").strip

        payload = {
          contents: {
            parts: [
              { text: "Summarize this content:\n\n#{product_text}" }
            ] 
          },
          system_instruction: { parts: [{ text: assistant.scrapping_instructions }] },
          generationConfig: { temperature: 0.5, topP: 0.8, topK: 1024 }
        }

        response = make_api_call(url: API_URL, payload: payload)

        product_attributes = JSON.parse(response.dig("candidates", 0, "content", "parts", 0, "text"))
        product_attributes["url_images"] = url_images

        product.update!(product_attributes)
      end

      private

      def extract_text_from_url(url)
        raise "url hasn`t been set up" if url.nil?

        ## TODO: this is in case of static pages... but
        ## what happend with dynamic pages?
        # browser = Ferrum::Browser.new
        # browser.goto(url)
        # html = browser.body

        response = HTTParty.get((url), { headers: @headers_scrapping })
        document = Nokogiri::HTML(response.body)

        document.search("script, style, nav, footer, header").remove

        # Extract visible text
        document
      end
    end
  end
end
