module AIService
  class Conversations

    attr_reader :service_class

    def self.new(*args)
      service_class = "AIService::#{args.first.assistant.company.ai_source.capitalize}Service::Conversations".constantize
      @service_class = service_class.new(*args)
    end

    def add_message(message)
      service_class.add_message(message)
    end
  end
end
