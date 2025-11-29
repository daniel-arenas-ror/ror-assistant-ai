module AIService
  module OpenaiService
    class Assistant < Base

      def initialize(assistant:)
        @assistant = assistant
        @openai = OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY"))
      end

      def process
        raise "assistant_id is requiered" if @assistant.assistant_id.blank?
        raise "Uodate is only for openai agent" if @assistant.use_openai?

        @openai.beta.assistants.update(@assistant.assistant_id, 
         {
          instructions: @assistant.full_instructions,
          temperature: @assistant.temperature,
          top_p: @assistant.top_p
         }
        )
      end
    end
  end
end
