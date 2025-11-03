module AIService
  module OpenaiService
    class Conversations < Base
      DEFAULT_POLL_INTERVAL_SECONDS = 1
      attr_accessor :openai, :assistant, :lead, :company, :conversation, :openai

      def initialize(
        assistant: nil,
        conversation: nil
      )
        @lead = conversation&.lead
        @company = assistant.company
        @assistant = assistant
        @conversation = conversation
        @openai = OpenAI::Client.new(
          api_key: ENV.fetch("OPENAI_API_KEY")
        )
      end

      def create_conversation(message)

        p " conversation"
        p conversation

        if lead.nil?
          lead = Lead.create!(
            name: "Lead #{Time.now.strftime("%Y%m%d%H%M%S")}",
          )

          lead_company = LeadCompany.create!(
            lead: lead,
            company: company
          )
        end

        p " conversation.nil? #{conversation.nil?}"
        p 1
        if conversation.nil?
          p 2
          p " enter here! create conversation "
          openai_thread = openai.beta.threads.create()
          p 3
          conversation = assistant.conversations.create!(
            lead: lead,
            thread_id: openai_thread.id
          )
          p 4
        end
        

        p 5
        p " conversation.nil? #{conversation.nil?}"
        
        p " conversation "
        p conversation

        p 6
        openai.beta.threads.messages.create(
          conversation.thread_id,
          { role: "user", content: message }
        )

        p 7
        conversation.messages.create!(
          role: "user",
          content: message
        )

        run = openai.beta.threads.runs.create(
          conversation.thread_id,
          { assistant_id: assistant.assistant_id }
        )

        run_id = run.id
        started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        loop do
          p " enter to loop "
          run =  openai.beta.threads.runs.retrieve(run_id, {thread_id: conversation.thread_id})
          status = run.status

          p " status #{status} "
          p " status #{status.class} "

          case status
          when :completed
            p " enter to completed "

            messages = openai.beta.threads.messages.list(conversation.thread_id)
            last_message = messages.data.dig(0).content[0].text.value

            conversation.messages.create!(
              role: "assistant",
              content: last_message,
              meta_data: {

              }
            )

            return conversation
          when :failed, :cancelled, :expired
            raise "Assistant run #{status}: #{run.inspect}"
          else
            p " enter to sleep "
            sleep(DEFAULT_POLL_INTERVAL_SECONDS)
          end

          elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at
          raise "Assistant run timed out" if elapsed > MAX_POLL_SECONDS
        end

      end
    end
  end
end
