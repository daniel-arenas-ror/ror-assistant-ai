module AIService
  module GeminiService
    class Conversations < Base
      include Tools::Base

      attr_reader :assistant, :conversation, :lead, :company, :openai, :broadcast_key, :system_instruction

      def initialize(
        assistant: nil,
        conversation: nil,
        broadcast_key: nil
      )
        @conversation = conversation
        @assistant = conversation&.assistant || assistant
        @lead = conversation&.lead
        @company = @assistant&.company
        @broadcast_key = broadcast_key
        @system_instruction = @assistant.instructions
        @history = conversation.messages.collect{|m| { "role" => m.role == "user" ? "user": "model", "parts" => [{ "text" => m.content }] } } || []
        @tools = []
      end

      def add_message(user_message)

        ensure_lead!
        ensure_conversation!

        @history << { "role" => "user", "parts" => [{ "text" => user_message }] }

        response_data = make_api_call(@history, @system_instruction, @tools)

        conversation_message = conversation.messages.create!(
          role: "user",
          content: user_message
        )

        p " **** response_data **** "
        ap response_data

        function_call = response_data['candidates']&.first&.dig('content', 'parts')&.find { |p| p['functionCall'] }

        if function_call
          puts "\n--- FUNCTION CALL DETECTED ---"
          function_name = function_call['functionCall']['name']
          function_args = function_call['functionCall']['args']

          send(function_name, JSON.parse(function_args))

          if function_name == 'search_products'
            result = search_products(function_args['query'])
            puts "Executed function `search_products` with query: '#{function_args['query']}'"

            @history << function_call['content']

            @history << {
              "role" => "function",
              "parts" => [
                {
                  "functionResponse" => {
                    "name" => "search_products",
                    "response" => { "content" => result }
                  }
                }
              ]
            }

            puts "--- RETURNING FUNCTION RESULT TO GEMINI ---"
            response_data = make_api_call(@history, @system_instruction, @tools)
          end
        end

        final_text = response_data['candidates']&.first&.dig('content', 'parts', 0, 'text')

        conversation_message = conversation.messages.create!(
          role: "assistant",
          content: final_text
        )

        if final_text
          @history << { "role" => "model", "parts" => [{ "text" => final_text }] }
          return final_text
        else
          return "Assistant failed to generate a response."
        end
      rescue StandardError => e
        return "An error occurred: #{e.message}"  
      end

      def ensure_lead!
        return if lead.present?

        @lead = Lead.create!(
          name: "Lead #{Time.current.strftime('%Y%m%d%H%M%S')}"
        )

        LeadCompany.create!(lead: @lead, company: company)
      end

      def ensure_conversation!
        return if conversation.present?

        @conversation = assistant.conversations.create!(
          lead: lead,
          company: company,
          meta_data: { agent: 'gemini', version: assistant.version }
        )
      end
    end
  end
end
