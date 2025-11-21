class BroadcastMessageAiChannel < ApplicationCable::Channel
  def subscribed
    assistant = Assistant.find_by_slug(params[:assistant_id])
    conversation = AIService::OpenaiService::Conversations.new(
        assistant: assistant
      ).add_message(params[:message])

    stream_for "broadcast_message_ai_channel_#{assistant.slug}_#{conversation.id}"
  end

  def speak(data)

    conversation = AIService::OpenaiService::Conversations.new(
      conversation: conversation
    ).add_message(params[:message])

    broadcast_to "broadcast_message_ai_channel_#{assistant.slug}_#{conversation.id}", { type: 'typing_end', content: data["message"] }
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    p " ** unsubscribed ** "
  end
end
