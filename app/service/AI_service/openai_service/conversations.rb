module AIService
  module OpenaiService
    class Conversations < Base
      include Tools::Base

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

        conversation_message = conversation.messages.create!(
          role: "user",
          content: message
        )

        BroadcastMessageAiChannel.broadcast_to broadcast_key, { type: 'user_message_added', content: conversation_message.content, id: conversation_message.id }
      end

      def start_run!
        run = openai.beta.threads.runs.create(
          conversation.thread_id,
          assistant_id: assistant.assistant_id
        )

        conversation.update!(current_run_id: run.id)
        BroadcastMessageAiChannel.broadcast_to broadcast_key, { type: 'typing_start' }

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
            BroadcastMessageAiChannel.broadcast_to broadcast_key, { type: 'typing_end' }

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

      def search_similar_properties(query)
        p " search_similar_properties #{query} "
        p " query[preferences] #{query["preferences"]} "

        embedding = @openai.embeddings.create(
          {
            model: "text-embedding-3-small",
            input: query["preferences"]
          }
        ).data[0].embedding

        # products = company.products.order(Arel.sql("embedding <-> '#{embedding.to_json}'")).limit(5)
        conn = ActiveRecord::Base.connection.raw_connection

        sql = <<-SQL
          SELECT id
          FROM products
          WHERE company_id = $1
          ORDER BY embedding <-> $2 LIMIT 5
        SQL

        product_ids = conn.exec_params(sql, [company.id, embedding]).to_a
        products = company.products.find(product_ids.collect{|i| i["id"]})

        products.collect(&:embed_input_with_img).join("\n")
      end

      ##
      # When assistant replies
      ##
      def handle_assistant_reply!
        messages = openai.beta.threads.messages.list(conversation.thread_id)
        last_message = messages.data.first.content.first.text.value

        conversation_message = conversation.messages.create!(
          role: "assistant",
          content: last_message
        )

        BroadcastMessageAiChannel.broadcast_to broadcast_key, { type: 'answered_message', id: conversation_message.id, content: last_message }
      end

      def get_scheduled(argument)
        # argument = JSON.parse(argument)

        "The current date #{Time.now}"
      end

      def create_scheduled(argument)
        # argument = JSON.parse(argument)

        "Tu agenda se ha creado"
      end

      def update_lead(argument)
        #argument = JSON.parse(argument)

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