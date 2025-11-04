class LeadsController < ApplicationController
  def index
    @users = current_company.leads
  end  
end
