class BroadcastMessageAiChannel < ApplicationCable::Channel
  def subscribed
    ## optional can come with conversation id
    ## the lead id should come here too
    assistant = Assistant.find_by_slug(params[:assistant_slug])
    conversation = AIService::OpenaiService::Conversations.new(
      assistant: assistant
    ).create_conversation

    broadcast_key = "broadcast_message_ai_channel_#{assistant.slug}_#{conversation.id}"
    stream_for broadcast_key

    broadcast_to broadcast_key, { type: 'set_conversation_id', content: conversation.id }
  end

  def speak(data)
    p " data[assistantSlug] #{data["assistantSlug"]}"

    broadcast_key = "broadcast_message_ai_channel_#{data["assistantSlug"]}_#{data["conversationId"]}"
    conversation = Assistant.find_by_slug(data["assistantSlug"]).conversations.find(data["conversationId"])

    conversation = AIService::OpenaiService::Conversations.new(
      conversation: conversation
    ).add_message(params[:message])

    last_message = conversation.messages.last

    broadcast_to broadcast_key, { type: 'answered_message', content: last_message.content, id: last_message.id }
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    p " ** unsubscribed ** "
  end
end

