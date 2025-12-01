module AIService
  module GeminiService
    class Conversations < Base
      include Tools::Base
      include ConversationsService::Messages

      API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
      GEMINI_API_KEY = ENV.fetch('GEMINI_API_KEY', '')

      attr_reader :assistant, :conversation, :lead, :company, :openai, :broadcast_key, :system_instruction, :history

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
        @history = conversation.messages.collect{|m| { role: m.role == "user" ? "user": "model", parts: [{ text: m.content }] } } || []
        @tools = []
        @url = API_URL
      end

      def add_message(user_message)
        ensure_lead!
        ensure_conversation!

        history << { role: "user", parts: [{ text: user_message }] }

        add_user_message(message)

        response_data = make_api_call(url, payload)

        start_typing_indicator

        p " **** response_data **** "
        ap response_data

        function_call = response_data['candidates']&.first&.dig('content', 'parts')&.find { |p| p['functionCall'] }

        if function_call
          puts "\n--- FUNCTION CALL DETECTED ---"
          function_name = function_call['functionCall']['name']
          function_args = function_call['functionCall']['args']

          result = send(function_name, JSON.parse(function_args))

          @history << function_call['content']

          @history << {
            role: "function",
            parts: [
              {
                functionResponse: {
                  name: "search_products",
                  response: { "content": result }
                }
              }
            ]
          }

          puts "--- RETURNING FUNCTION RESULT TO GEMINI ---"
          response_data = make_api_call(url, payload)
        end

        final_text = response_data['candidates']&.first&.dig('content', 'parts', 0, 'text')

        end_typing_indicator

        add_model_message(final_text)

        if final_text
          @history << { "role" => "model", "parts" => [{ "text" => final_text }] }
          return final_text
        else
          return "Assistant failed to generate a response."
        end
      rescue StandardError => e
        return "An error occurred: #{e.message}"  
      end

      def payload
        {
          contents: history,
          system_instruction: { parts: [{ text: system_instruction }] },
          tools: [{ functionDeclarations: [tool_spec] }]
        }
      end
    end
  end
end
