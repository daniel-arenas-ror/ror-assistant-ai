class BroadcastMessageAiChannel < ApplicationCable::Channel
  def subscribed
    p " ** subscribed ** "
    # stream_from "some_channel"
    p "parameters: #{params}"
    stream_for "broadcast_message_ai_channel_#{params['conversation_id']}"
  end

  def receive(data)
    p " ** receive ** "
    p "data received in receive: #{data}"

    ActionCable.server.broadcast("broadcast_message_ai_channel", data)
  end

  def speak(data)
    p " ** speak ** "
    p params

    p " data in speak: #{data["message"]} "

    broadcast_to "broadcast_message_ai_channel_#{params['conversation_id']}", { type: 'typing_start', content: data["message"] }

    sleep 5

    broadcast_to "broadcast_message_ai_channel_#{params['conversation_id']}", { type: 'message_chunk', content: data["message"] }

    sleep 2
    broadcast_to "broadcast_message_ai_channel_#{params['conversation_id']}", { type: 'typing_end', content: data["message"] }
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    p " ** unsubscribed ** "
  end
end
