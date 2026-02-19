class OptionTypesController < ApplicationController
  before_action :set_option_type, only: [:edit, :update]

  def index
    @option_types = current_company.option_types
  end

  def new
    @option_type = current_company.option_types.new
  end

  def create
    @option_type = current_company.option_types.new(option_types_params)

    if @option_type.save
      redirect_to option_types_path, notice: "Tipo de opción creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @option_type.update(option_types_params)
      redirect_to option_types_path, notice: "Tipo de opción actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def option_types_params
    params.require(:option_type).permit(:name)
  end

  def set_option_type
    @option_type = current_company.option_types.find(params[:id])
  end
end
