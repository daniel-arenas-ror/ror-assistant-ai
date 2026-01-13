module AIService
  module GrokService
    class ScrapeProduct < Base
      attr_accessor :product, :assistant
      attr_reader :document, :headers_scrapping

      API_URL = "https://api.x.ai/v1/responses"
      MODEL_NAME = "grok-4"

      def initialize(product:)
        super(ENV.fetch('GROK_API_KEY', ''))

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
          model: MODEL_NAME,
          input: [
            { role: "system", content: assistant.scrapping_instructions },
            { role: "user", content: "Summarize this content:\n\n#{product_text}" }
          ]
        }

        response = make_api_call(url: API_URL, payload: payload)

        p " response.dig(output, 0, content, 0) "
        p response.dig("output", 0, "content", 0, "text")
        p " --------- "

        product_attributes = JSON.parse(response.dig("output", 0, "content", 0, "text"))
        product_attributes["url_images"] = url_images

        product.update!(product_attributes)
      end

      private

      def extract_text_from_url(url)
        raise "url hasn`t been set up" if url.nil?

        response = HTTParty.get((url), { headers: @headers_scrapping })
        document = Nokogiri::HTML(response.body)

        document.search("script, style, nav, footer, header").remove

        # Extract visible text
        document
      end
    end
  end
end
