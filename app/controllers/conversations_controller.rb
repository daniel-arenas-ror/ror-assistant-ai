class ConversationsController < ApplicationController
  def index
    @conversations = current_company.conversations.includes(:lead).order(created_at: :desc)
  end

  def show
    @conversation = current_company.conversations.find(params[:id])
    @lead = @conversation.lead
    @messages = @conversation.messages.order(created_at: :asc)
  end
end
