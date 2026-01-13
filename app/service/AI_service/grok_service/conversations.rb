module AIService
  module GrokService
    class Conversations < Base
      include ::Tools::Base
      include ::ConversationsService::Messages

      API_URL = "https://api.x.ai/v1/chat/completions"
      GROK_API_KEY = ENV.fetch('GROK_API_KEY', '')
      MODEL_NAME = "grok-beta" 

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
        @system_instruction = @assistant.instructions
        @history = [{ "role": "system", "content": @system_instruction }]
        @tools = @assistant.tools.collect{|f| JSON.parse(f.function)} || []
        @url = API_URL
      end

      def add_message(user_message)
        ensure_lead!
        ensure_conversation!

        @history << grok_history_formatted

        add_user_message(user_message)

        p " payload "
        p payload
        p " ************ "

        response_data = make_api_call(url: url, payload: payload)

        start_typing_indicator

        p " response data "
        p response_data

        last_message = response_data.dig("choices", 0, "message", "content") || ""

        end_typing_indicator

        add_model_message(last_message)

        if final_text
          return conversation
        else
          raise "Assistant failed to generate a response."
        end
      end
    end
  end
end
