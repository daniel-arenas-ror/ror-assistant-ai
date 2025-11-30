module AIService
  module GeminiService
    class ScrapeProduct < Base
      attr_accessor :product, :assistant

      API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

      def initialize(product:, headers: nil)
        super(ENV.fetch('GEMINI_API_KEY', ''))

        @product = product
        @assistant = product.company.assistant
      end

      def process
        url = product.url
        product_text = extract_text_from_url(url)

        p " ** product_text ** "
        p product_text
        p " ------ "

        url_images = product_text.css('img').map { |img| img['src'] }.compact.uniq
        product_text = product_text.text.gsub(/\s+/, " ").strip

        payload = {
          contents: {
            parts: [
              { text: "Summarize this content:\n\n#{product_text}" }
            ] 
          },
          system_instruction: { parts: [{ text: assistant.scrapping_instructions }] }
        }


        response = make_api_call(url: API_URL, payload: payload)

        product_attributes = JSON.parse(response.choices[0].message.content)
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

        response = HTTParty.get((url), { headers: @headers })
        document = Nokogiri::HTML(response.body)

        document.search("script, style, nav, footer, header").remove

        # Extract visible text
        document
      end
    end
  end
end
