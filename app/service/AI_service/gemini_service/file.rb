module AIService
  module GeminiService
    class File < Base
      FILE_API_BASE_URL = "https://generativelanguage.googleapis.com/v1beta/files"

      def initialize(api_key)
        super(ENV.fetch('GEMINI_API_KEY', ''))

      end

      def upload_file(file_path:)
        payload = {
          file: {
            content: Base64.strict_encode64(File.read(file_path)),
            filename: File.basename(file_path),
            mime_type: "application/octet-stream"
          }
        }

        response_data = make_api_call(url: FILE_API_BASE_URL, payload: payload)

        response_data
      end

      def delete_file(file_id:)
        url = "#{FILE_API_BASE_URL}/#{file_id}"
        response = make_api_call(url, method: :delete)

        if response.code == 200
          { message: "File deleted successfully." }
        else
          raise "API Error: #{response.code} - #{response.body}"
        end
      end

    end
  end
end
