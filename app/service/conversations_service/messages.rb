module ConversationsService
  module Messages
    def add_user_message(message)
      conversation_message = conversation.messages.create!(
        role: "user",
        content: message
      )

      BroadcastMessageAiChannel.broadcast_to broadcast_key, { type: 'user_message_added', content: conversation_message.content, id: conversation_message.id } if broadcast_key.present?
    end

    def add_model_message(last_message)
      conversation_message = conversation.messages.create!(
        role: "assistant",
        content: last_message
      )

      BroadcastMessageAiChannel.broadcast_to broadcast_key, { type: 'answered_message', id: conversation_message.id, content: last_message }  if broadcast_key.present?
    end

    def add_function_message(parts)
      conversation_message = conversation.messages.create!(
        role: "function",
        meta_data: parts
      )
    end

    def gemini_history_formatted
      conversation&.messages&.collect do |m|
        role = m.role == "assistant" ? "model" : m.role
        parts = role == "function" ? m.meta_data : [{ text: m.content }]

        { role: role, parts: parts }
      end
    end

    def start_typing_indicator
      BroadcastMessageAiChannel.broadcast_to broadcast_key, { type: 'typing_start' } if broadcast_key.present?
    end

    def end_typing_indicator
      BroadcastMessageAiChannel.broadcast_to broadcast_key, { type: 'typing_end' } if broadcast_key.present?
    end
  end
end
