module AIService
  module GeminiService
    class Conversations < Base
      include ::Tools::Base
      include ::ConversationsService::Messages

      API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=#{ENV.fetch('GEMINI_API_KEY', '')}"
      GEMINI_API_KEY = ENV.fetch('GEMINI_API_KEY', '')

      attr_reader :assistant,
        :conversation,
        :lead,
        :company,
        :openai,
        :broadcast_key,
        :system_instruction,
        :history,
        :tools,
        :url

      def initialize(
        assistant: nil,
        conversation: nil,
        broadcast_key: nil
      )
        super(ENV.fetch('GEMINI_API_KEY', ''))

        @conversation = conversation
        @assistant = conversation&.assistant || assistant
        @lead = conversation&.lead
        @company = @assistant&.company
        @broadcast_key = broadcast_key
        @system_instruction = @assistant.instructions
        @history = gemini_history_formatted || []
        @tools = @assistant.tools.collect{|f| JSON.parse(f.function)} || []
        @url = API_URL
      end

      def add_message(user_message)
        p " create lead "
        ensure_lead!

        p " create conversation "
        ensure_conversation!

        history << { role: "user", parts: [{ text: user_message }] }

        p " add history "
        # debugger

        add_user_message(user_message)

        p " payload "
        p payload
        p " ************ "

        response_data = make_api_call(url: url, payload: payload)

        start_typing_indicator

        p " **** response_data **** "
        ap response_data

        function_call = response_data['candidates']&.first&.dig('content', 'parts')&.find { |p| p['functionCall'] }

        if function_call
          puts "\n--- FUNCTION CALL DETECTED ---"
          function_name = function_call['functionCall']['name']
          function_args = function_call['functionCall']['args']

          result = send(function_name, function_args)

          parts = [{
              functionResponse: {
                name: function_call['functionCall']['name'],
                response: { "content": result }
              }
            }
          ]

          add_function_message(parts)

          @history << {
            role: "function",
            parts: parts
          }

          puts "--- RETURNING FUNCTION RESULT TO GEMINI ---"
          response_data = make_api_call(url: url, payload: payload)
        end

        final_text = response_data['candidates']&.first&.dig('content', 'parts', 0, 'text')

        end_typing_indicator

        add_model_message(final_text)

        if final_text
          return conversation
        else
          raise "Assistant failed to generate a response."
        end
      end

      def payload
        {
          contents: history,
          system_instruction: { parts: [{ text: system_instruction }] },
          tools: [
            {
              functionDeclarations: tools,
              file_search: {
                file_search_store_names: ["fileSearchStores/testfile-ooycu8edwf4b"]
              } 
            }
          ],
          generation_config: {
            temperature: assistant.temperature || 1.0,
            topP: assistant.top_p || 0.9,
          }
        }
      end

      def file_data_formatted

        files = []

        files.push({ file_data: { mime_type: "application/pdf", fileUri: "fileSearchStores/testfile-ooycu8edwf4b/operations/3w8kc8ei0vqh-3x8zwn3669ov" } })

        # files.push({ file_data: { mime_type: "application/octet-stream", fileUri: "gs://my-bucket/my-object" } })
 
        return files

        file_data = assistant.file_data || []
        return [] if @file_data.empty?

        file_data.collect do |m|
           { fileData: { mimeType: "application/octet-stream", fileUri: res_name } }
        end
      end
    end
  end
end
