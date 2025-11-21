class BroadcastMessageAiChannel < ApplicationCable::Channel
  def subscribed
    p " ** subscribed ** "
    # stream_from "some_channel"
    p "parameters: #{params}"
    stream_for "broadcast_message_ai_channel_#{params['conversation_id']}"
    ActionCable.server.broadcast "broadcast_message_ai_channel_#{params['conversation_id']}", { action: 'updateMessages', messages: "messages" }
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

    ActionCable.server.broadcast("broadcast_message_ai_channel_#{params['conversation_id']}", { action: 'updateMessages', messages: "messages" })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    p " ** unsubscribed ** "
  end
end
