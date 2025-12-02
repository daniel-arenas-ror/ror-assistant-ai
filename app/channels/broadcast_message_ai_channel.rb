class BroadcastMessageAiChannel < ApplicationCable::Channel
  def subscribed
    ## optional can come with conversation id
    ## the lead id should come here too
    assistant = Assistant.find_by_slug(params[:assistant_slug])

    if params["conversation_id"]
      conversation = assistant.conversations.find(params["conversation_id"])
    else
      conversation = AIService::Conversations.new(
        assistant: assistant
      ).create_conversation
    end

    broadcast_key = "broadcast_message_ai_channel_#{assistant.slug}_#{conversation.id}"
    stream_for broadcast_key

    broadcast_to(broadcast_key, { type: 'initial_load',
      content: conversation.id,
      messages: conversation.conversation_messages.map { |m| { id: m.id, role: m.role, content: m.content } }
    })
  end

  def speak(data)
    p " data[assistantSlug] #{data["assistantSlug"]}"
    p " data[conversationId] #{data["conversationId"]}"

    broadcast_key = "broadcast_message_ai_channel_#{data["assistantSlug"]}_#{data["conversationId"]}"
    conversation = Assistant.find_by_slug(data["assistantSlug"]).conversations.find(data["conversationId"])

    AIService::Conversations.new(
      conversation: conversation,
      broadcast_key: broadcast_key
    ).add_message(data["message"])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    p " ** unsubscribed ** "
  end
end

