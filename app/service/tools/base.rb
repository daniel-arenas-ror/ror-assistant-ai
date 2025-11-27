module Tools
  module Base

    def ensure_lead!
      return if lead.present?

      @lead = Lead.create!(
        name: "Lead #{Time.current.strftime('%Y%m%d%H%M%S')}"
      )

      LeadCompany.create!(lead: @lead, company: company)
    end

    def ensure_conversation!
      return if conversation.present?

      thread = openai.beta.threads.create
      @conversation = assistant.conversations.create!(
        lead: lead,
        thread_id: thread.id,
        company: company,
        meta_data: { agent: 'openai', version: assistant.version }
      )
    end
  end
end
