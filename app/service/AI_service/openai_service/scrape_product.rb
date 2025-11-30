module AIService
  module OpenaiService
    class ScrapeProduct

      attr_accessor :product, :openai, :assistant
      attr_reader :document, :headers

      MODEL = "gpt-4.1-mini"

      def initialize(product:, headers: nil)
        @openai = OpenAI::Client.new(
          api_key: ENV.fetch("OPENAI_API_KEY")
        )
        @product = product
        @assistant = product.company.assistant
        @headers = headers || {
          "user-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
        }
      end

      def process
        url = product.url
        product_text = extract_text_from_url(url)

        url_images = product_text.css('img').map { |img| img['src'] }.compact.uniq
        product_text = product_text.text.gsub(/\s+/, " ").strip

        response = openai.chat.completions.create(
          {
            model: MODEL,
            messages: [
              { role: "system", content: assistant.scrapping_instructions },
              { role: "user", content: "Summarize this content:\n\n#{product_text}" }
            ]
          }
        )

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
