class LeadsController < ApplicationController
  before_action :load_lead, only: [:show]

  def index
    @leads = current_company.leads
  end

  def show
    @lead = current_company.leads.find(params[:id])
    @conversations = @lead.conversations
  end

  private

  def load_lead
    @lead = current_company.leads.find(params[:id])
  end
end
