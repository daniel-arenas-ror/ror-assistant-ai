module Public
  class ConversationsController < BaseController
    before_action :set_assistant
    before_action :set_conversation, only: [:edit, :update]

    def new
      @conversation = @assistant.conversations.new
    end

    def create
      @conversation = AIService::OpenaiService::Conversations.new(
        assistant: @assistant
      ).add_message(params[:message])

      p " @conversation "
      p @conversation
      p " ************* "

      p " @conversation.save "
      p @conversation.save
      p " ************ "

      if @conversation.save
        respond_to do |format|
          format.html { redirect_to edit_public_conversation_path(@conversation, assistant_id: @assistant.slug), notice: "ok" }
          # format.turbo_stream { flash.now[:notice] = "ok" }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      @conversation = AIService::OpenaiService::Conversations.new(
        conversation: @conversation
      ).add_message(params[:message])

      if @conversation.save
        respond_to do |format|
          format.html { redirect_to edit_public_conversation_path(@conversation, assistant_id: @assistant.slug), notice: "ok" }
          #format.turbo_stream { flash.now[:notice] = "Quote was successfully updated." }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private


    def set_assistant
      @assistant = Assistant.find_by_slug(params[:assistant_id])
    end

    def set_conversation
      @conversation = @assistant.conversations.find(params[:id])
    end
  end
end