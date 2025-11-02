class RealEstatesController < ApplicationController
  def index
    @real_estates = current_company.real_estates
  end  
end