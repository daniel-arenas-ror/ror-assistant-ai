module AIService
  module GrokService
    class Conversations < Base
      include ::Tools::Base
      include ::ConversationsService::Messages

      API_URL = "https://api.x.ai/v1/chat/completions"
      GROK_API_KEY = ENV.fetch('GROK_API_KEY', '')
      MODEL_NAME = "grok-4"

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
        super(ENV.fetch('GROK_API_KEY', ''))

        @conversation = conversation
        @assistant = conversation&.assistant || assistant
        @lead = conversation&.lead
        @company = @assistant&.company
        @broadcast_key = broadcast_key
        @system_instruction = @assistant.full_instructions
        @history = [{ "role": "system", "content": @system_instruction }]
        @tools = []
        @url = API_URL
      end

      def add_message(user_message)
        ensure_lead!
        ensure_conversation!

        @tools = set_tools_for_grok

        @history << grok_history_formatted

        @history << { role: "user", content: user_message }

        add_user_message(user_message)

        @history = @history.flatten

        p " payload "
        p payload
        p " ************ "

        response_data = make_api_call(url: url, payload: payload)

        start_typing_indicator

        p " response data "
        p response_data

        functions_call = response_data.dig("choices", 0, "message", "tool_calls") || []

        if functions_call.any?
          puts "\n--- FUNCTION CALL DETECTED ---"

          functions_call.each do |function_call|
            function_id   = function_call.dig('id')
            function_name = function_call.dig('function', "name")
            function_args = function_call.dig('function', "arguments")

            result = send(function_name, function_args)

            parts = []
            parts.push({
              role: "tool",
              content: result,
              tool_call_id: function_id
            })

            add_function_message(parts)

            @history << {
              role: "tool",
              content: result,
              tool_call_id: function_id
            }

            response_data = make_api_call(url: url, payload: payload)
          end

          # debugger
        end

        last_message = response_data.dig("choices", 0, "message", "content") || ""

        end_typing_indicator

        add_model_message(last_message)

        if last_message
          return conversation
        else
          raise "Assistant failed to generate a response."
        end
      end

      def payload
        {
          model: MODEL_NAME,
          messages: @history,
          tools: @tools,
          tool_choice: "auto"
        }
      end

      def grok_history_formatted
        conversation&.messages.where.not(role: "function")&.collect do |m|
          { role: m.role, content: m.content }
        end
      end

      def set_tools_for_grok
        @assistant.tools.collect do |t|
          {
            type: "function",
            function: JSON.parse(t.function)
          }
        end
      end
    end
  end
end
