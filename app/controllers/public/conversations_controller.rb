module Public
  class ConversationsController < BaseController
    def new
      @assistant = Assistant.first
      @conversation = @assistant.conversations.sample
    end

    def edit
    end
  end
end