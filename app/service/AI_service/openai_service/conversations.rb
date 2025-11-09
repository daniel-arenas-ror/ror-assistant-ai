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

        p " company "
        p company

        p " @assistant "
        p assistant

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

        @lead = Lead.create!(
          name: "Lead #{Time.current.strftime('%Y%m%d%H%M%S')}"
        )

        p " company "
        p company

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
        p " run_id #{run_id}"

        loop do
          run = openai.beta.threads.runs.retrieve(run_id, thread_id: conversation.thread_id)

          puts " run.status #{run.status}"

          case run.status.to_sym
          when :completed
            p " completed "
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

            run.required_action.submit_tool_outputs

          when :failed, :cancelled, :expired
            p " :failed, :cancelled, :expired "

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

        conversation.messages.create!(
          role: "assistant",
          content: last_message
        )
      end

      def get_scheduled(argument)
        argument = JSON.parse(argument)

        "The current date #{Time.now}"
      end

      def create_scheduled(argument)
        argument = JSON.parse(argument)

        "Tu agenda se ha creado"
      end

      def update_lead(argument)
        argument = JSON.parse(argument)

        lead.update!(
          email: argument["email"],
          phone: argument["phone_number"],
          name: argument["name"],
          preferences: argument["extra_information"],
          extra_data: argument["extra_information"],
        )

        lead_company = lead.lead_companies.find(company_id: company.id)
        lead_company.update!(
          summary: argument["extra_information"]
        )

        "tus datos se han actualizado"
      end
    end
  end
end