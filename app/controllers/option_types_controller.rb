class OptionTypesController < ApplicationController
  before_action :set_product, only: [:edit, :update, :scrape]

  def index
    @option_types = current_company.option_types
  end

  private

  def option_types_params
    params.require(:option_type).permit(:name, :values)
  end
end
