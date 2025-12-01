module AIService
  class Conversations

    attr_reader :service_class

    def self.new(assistant: nil, conversation: nil, broadcast_key: nil)
      ai_source = conversation&.assistant&.company&.ai_source || assistant&.company&.ai_source
      service_class = "AIService::#{ai_source.capitalize}Service::Conversations".constantize
      @service_class = service_class.new(
        assistant: assistant,
        conversation: conversation,
        broadcast_key: broadcast_key
      )
    end

    def add_message(message)
      service_class.add_message(message)
    end
  end
end
