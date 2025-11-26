module AIService
  module GeminiService
    class Conversations < Base

      attr_reader :assistant, :conversation, :lead, :company, :openai, :broadcast_key

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
      end

      def send_message(user_message)
        @history << { "role" => "user", "parts" => [{ "text" => user_message }] }

        response_data = make_api_call(@history, SYSTEM_INSTRUCTION, TOOL_SPEC)

        function_call = response_data['candidates']&.first&.dig('content', 'parts')&.find { |p| p['functionCall'] }

        if function_call
          puts "\n--- FUNCTION CALL DETECTED ---"
          function_name = function_call['functionCall']['name']
          function_args = function_call['functionCall']['args']
          
          # Step 3: Execute the local function
          if function_name == 'search_products'
            result = search_products(function_args['query'])
            puts "Executed function `search_products` with query: '#{function_args['query']}'"
            
            # Step 4: Add the model's function request and the function result to history
            @history << function_call['content'] # The model's request (role: 'model')
            
            # The function result response (role: 'function')
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
            # Step 5: Second API Call: Send function result back to get the final text response
            response_data = make_api_call(@history, SYSTEM_INSTRUCTION, TOOL_SPEC)
          end
        end

        final_text = response_data['candidates']&.first&.dig('content', 'parts', 0, 'text')

        if final_text
          @history << { "role" => "model", "parts" => [{ "text" => final_text }] }
          return final_text
        else
          return "Assistant failed to generate a response."
        end
      rescue StandardError => e
        return "An error occurred: #{e.message}"  
      end
    end
  end
end
