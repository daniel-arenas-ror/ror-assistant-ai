module AIService
  module OpenaiService
    class Conversations < Base
      include Tools::Base
      include ConversationsService::Messages

      DEFAULT_POLL_INTERVAL_SECONDS = 1
      MAX_POLL_SECONDS = 90

      attr_reader :assistant, :conversation, :lead, :company, :openai, :broadcast_key

      def initialize(assistant: nil, conversation: nil, broadcast_key: nil)
        @conversation = conversation
        @assistant = conversation&.assistant || assistant
        @lead = conversation&.lead
        @company = @assistant&.company
        @broadcast_key = broadcast_key

        @openai = OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY"))
      end

      def add_message(message)
        ensure_lead!
        ensure_conversation!

        create_user_message!(message)
        run = start_run!

        wait_for_run_completion(run.id)

        conversation
      end

      private

      def create_user_message!(message)

        if conversation.current_run_id.present?
          run = openai.beta.threads.runs.retrieve(conversation.current_run_id, thread_id: conversation.thread_id)
          p " run.status before creating user message #{run.status}"
          ## Cancel current run
          openai.beta.threads.runs.cancel(conversation.current_run_id, thread_id: conversation.thread_id) if run.status.to_s != "completed"
          conversation.update!(current_run_id: nil)
        end

        openai.beta.threads.messages.create(
          conversation.thread_id,
          role: "user",
          content: message
        )

        add_user_message(message)
      end

      def start_run!
        run = openai.beta.threads.runs.create(
          conversation.thread_id,
          assistant_id: assistant.assistant_id
        )

        conversation.update!(current_run_id: run.id)
        start_typing_indicator

        run
      end

      def wait_for_run_completion(run_id)
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        p " run_id #{run_id}"

        loop do
          run = openai.beta.threads.runs.retrieve(run_id, thread_id: conversation.thread_id)

          puts " run.status #{run.status}"

          case run.status.to_sym
          when :completed
            p " completed "

            conversation.update!(current_run_id: nil)
            end_typing_indicator

            handle_assistant_reply!
            return
          when :requires_action
            p " requires_action "

            tool_outputs = []
            run.required_action.submit_tool_outputs.tool_calls.each do |call|

              p " call "
              p call
              p " **** ** "

              call_id = call.id
              output = send(call.function.name, JSON.parse(call.function.arguments))

              tool_outputs.push({
                tool_call_id: call_id,
                output: output
              })
            end

            # debugger

            openai.beta.threads.runs.submit_tool_outputs(
              run_id,
              {
                thread_id: conversation.thread_id,
                tool_outputs: tool_outputs
              }
            )

          when :failed, :cancelled, :expired
            p " :failed, :cancelled, :expired "
            conversation.update!(current_run_id: nil)

            raise "Assistant run #{run.status}: #{run.inspect}"
          else
            sleep(DEFAULT_POLL_INTERVAL_SECONDS)
          end

          p " end of the loop "
          raise "Assistant run timed out" if Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time > MAX_POLL_SECONDS
        end
      end

      ##
      # When assistant replies
      ##
      def handle_assistant_reply!
        messages = openai.beta.threads.messages.list(conversation.thread_id)
        last_message = messages.data.first.content.first.text.value

        add_model_message(last_message)
      end

    end
  end
end