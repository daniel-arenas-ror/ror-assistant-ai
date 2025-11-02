module AIService
  module OpenaiService
    class Base
      DEFAULT_POLL_INTERVAL_SECONDS = 0.5
      MAX_POLL_SECONDS = 60

      def initialize(
        assistant_id: ENV["OPENAI_ASSISTANT_ID"],
        client: OPENAI_CLIENT
      )
        @assistant_id = assistant_id
        @client = client
      end

      def converse(user_message)
        thread = create_thread
        add_message(thread_id: thread["id"], content: user_message)
        run = create_run(thread_id: thread["id"]) 
        wait_for_run_completion(thread_id: thread["id"], run_id: run["id"]) 
        latest_assistant_message(thread_id: thread["id"]) 
      end

      private

      def create_thread
        response = @client.beta.threads.create
        #response.fetch("data", response)
      end

      def add_message(thread_id:, content:, role: "user")
        @client.beta.threads.messages.create(
          thread_id: thread_id,
          role: role,
          content: content
        )
      end

      def create_run(thread_id:)
        @client.runs.create(
          thread_id: thread_id,
          assistant_id: @assistant_id
        )
      end

      def wait_for_run_completion(thread_id:, run_id:)
        started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        loop do
          run = @client.runs.retrieve(thread_id: thread_id, id: run_id)
          status = run["status"]
          case status
          when "completed"
            return run
          when "failed", "cancelled", "expired"
            raise "Assistant run #{status}: #{run.inspect}"
          else
            sleep(DEFAULT_POLL_INTERVAL_SECONDS)
          end

          elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at
          raise "Assistant run timed out" if elapsed > MAX_POLL_SECONDS
        end
      end

      def latest_assistant_message(thread_id:)
        messages = @client.messages.list(thread_id: thread_id)
        data = messages["data"] || []
        assistant_msg = data.find { |m| m["role"] == "assistant" } || data.first
        return nil unless assistant_msg

        parts = assistant_msg.dig("content") || []
        text_part = parts.find { |p| p.dig("type") == "text" }
        text_part&.dig("text", "value")
      end
    end
  end
end
