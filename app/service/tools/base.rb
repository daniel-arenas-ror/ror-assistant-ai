module Tools
  module Base

    def create_conversation
      ensure_lead!
      ensure_conversation!
    end

    def ensure_lead!
      return if lead.present?

      @lead = Lead.create!(
        name: "Lead #{Time.current.strftime('%Y%m%d%H%M%S')}"
      )

      LeadCompany.create!(lead: @lead, company: company)
    end

    def ensure_conversation!(thread: nil)
      return if conversation.present?

      @conversation = assistant.conversations.create!(
        lead: lead,
        thread_id: thread&.id,
        company: company,
        meta_data: { agent: company.ai_source, version: assistant.version }
      )
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

    def search_similar_properties(query)
      query = query.is_a?(String) ? JSON.parse(query) : query

      p " search_similar_properties #{query} "

      embedding = ::AIService::Embedding.new(company: company).generate_embedding(text: query["preferences"])

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
  end
end
