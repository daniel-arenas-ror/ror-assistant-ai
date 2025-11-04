module AIService
  module OpenaiService
    class Conversations < Base
      DEFAULT_POLL_INTERVAL_SECONDS = 1
      MAX_POLL_SECONDS = 60

      attr_reader :assistant, :conversation, :lead, :company, :openai

      def initialize(assistant: nil, conversation: nil)
        @conversation = conversation
        @assistant = conversation&.assistant || assistant
        @lead = conversation&.lead
        @company = @assistant&.company
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

      ##
      # Lead handling
      ##
      def ensure_lead!
        return if lead.present?

        @lead = Lead.create!(name: "Lead #{Time.current.strftime('%Y%m%d%H%M%S')}")
        LeadCompany.create!(lead: @lead, company: company)
      end

      ##
      # Conversation handling
      ##
      def ensure_conversation!
        return if conversation.present?

        thread = openai.beta.threads.create
        @conversation = assistant.conversations.create!(
          lead: lead,
          thread_id: thread.id
        )
      end

      ##
      # Messaging
      ##
      def create_user_message!(message)
        openai.beta.threads.messages.create(
          conversation.thread_id,
          role: "user",
          content: message
        )

        conversation.messages.create!(
          role: "user",
          content: message
        )
      end

      ##
      # Runs
      ##
      def start_run!
        openai.beta.threads.runs.create(
          conversation.thread_id,
          assistant_id: assistant.assistant_id
        )
      end

      def wait_for_run_completion(run_id)
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        loop do
          run = openai.beta.threads.runs.retrieve(run_id, thread_id: conversation.thread_id)

          puts " run.status #{run.status}"

          case run.status.to_sym
          when :completed
            handle_assistant_reply!
            return
          when :failed, :cancelled, :expired
            raise "Assistant run #{run.status}: #{run.inspect}"
          else
            sleep(DEFAULT_POLL_INTERVAL_SECONDS)
          end

          raise "Assistant run timed out" if Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time > MAX_POLL_SECONDS
        end
      end

      ##
      # When assistant replies
      ##
      def handle_assistant_reply!
        messages = openai.beta.threads.messages.list(conversation.thread_id)
        last_message = messages.data.first.content.first.text.value

        conversation.messages.create!(
          role: "assistant",
          content: last_message
        )
      end
    end
  end
end