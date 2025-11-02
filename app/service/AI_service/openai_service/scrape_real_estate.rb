module AIService
  module OpenaiService
    class ScrapeRealEstate

      attr_accessor :real_estate
      attr_reader :document, :headers

      def initialize(real_estate:, headers: nil)
        @real_estate = real_estate
        @headers = headers || {
          "user-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
        }
      end

      def process
        url = real_estate.url

        p " url "
        p url 



        p " ** parser **"
        p parser
        p " ------------ "

      end

      private

      def get_html_document(url)
        raise "url hasn`t been set up" if url.nil?

        response = HTTParty.get((url || URL), { headers: @headers })
        document = Nokogiri::HTML(response.body)

        return document

        ## TODO: check what is better, send to the AI the full document or sremove all html tags ##
        response = HTTParty.get((url), { headers: @headers })

        html = response.encode('UTF-8').gsub(/\P{ASCII}/, '')

        parser = Nokogiri::HTML(html, nil, Encoding::UTF_8.to_s)
        parser.xpath('//script')&.remove
        parser.xpath('//style')&.remove
        parser.xpath('//text()').map(&:text).join(' ').squish
      end
    end
  end
end
