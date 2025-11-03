module AIService
  module OpenaiService
    class ScrapeRealEstate

      attr_accessor :real_estate
      attr_reader :document, :headers

      MODEL = "gpt-4.1-mini"
      SCRAPPING_PROMPT = <<-TEXT
      You are an expert in extracting real estate information from raw web page text.

      Your task is to return ONLY a valid JSON object (no explanations, no extra text, no markdown).  
      If a field cannot be found, return it as an empty string "" or an empty array [].

      Extract the following fields:

      {
        "name": "Title or main name of the real estate property",
        "code": "Reference, ID, or code shown on the website (if any)",
        "url_images": ["Array of image URLs"],
        "description": "General description of the property (cleaned, without HTML or ads)",
        "amenities": "Main features such as number of rooms, bathrooms, parking, etc.",
        "location": "Address or description of where the property is located, including nearby places"
      }

      RULES:
      - Output MUST be valid JSON (double quotes, no comments, no trailing commas).
      - Do NOT include HTML tags, icons, emojis, scripts, prices, or promotional content.
      - Summarize long text but keep the key details.
      - The `url_images` field must contain ONLY full valid URLs (skip thumbnails/logos).
      - The `amenities` field should be a readable text block or bullet list separated by line breaks.
      - Do NOT invent data. If something is missing, leave it empty.
      - If the output is not valid JSON, you MUST fix it and re-output valid JSON.

      Example output:

      {
        "name": "Detached house for sale in Lang Stracht, Alford, AB33",
        "code": "ad427c54",
        "url_images": [
          "https://cdn2-property.estateapps.co.uk/files/property/370/image/ad427c54-3b35-4923-8b61-ce6a84181e78/28983435_CAM02631G0-PR0245-STILL002.jpg"
        ],
        "description": "5 bedroom detached house located in Alford, offering spacious accommodation with triple garages, office space, and outdoor entertaining areas.",
        "amenities": "5 bedrooms\n5 bathrooms\n3 living rooms\nTriple garage\nHome office space\nGarden and outdoor space\nViews to golf course",
        "location": "Alford village, next to local golf course, parks and woodland"
      }
      TEXT

      def initialize(real_estate:, headers: nil)
        @real_estate = real_estate
        @headers = headers || {
          "user-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
        }
      end

      def process
        url = real_estate.url
        real_estate_text = extract_text_from_url(url)

        # @openai
        # I going to give you a html page of a property, 
        response = @openai.chat.completions.create(
          {
            model: MODEL,
            messages: [
              { role: "system", content: SCRAPPING_PROMPT },
              { role: "user", content: "Summarize this content:\n\n#{real_estate_text}" }
            ]
          }
        )

        real_estate_attributes = JSON.parse(response.choices[0].message.content)
        real_estate.update!(real_estate_attributes)
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
        document.text.gsub(/\s+/, " ").strip
      end
    end
  end
end
