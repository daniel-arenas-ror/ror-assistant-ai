class OptionTypesController < ApplicationController
  before_action :set_option_type, only: [:edit, :update, :destroy]

  def index
    @option_types = current_company.option_types
  end

  def new
    @option_type = current_company.option_types.new
    @option_type.option_values.build
  end

  def create
    @option_type = current_company.option_types.new(option_types_params)

    if @option_type.save
      redirect_to edit_option_type_path(@option_type), notice: "Tipo de opción creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @option_type.update(option_types_params)
      redirect_to edit_option_type_path(@option_type), notice: "Tipo de opción actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def add_value
    helpers.fields_for :option_type, current_company.option_types.new do |f|
      f.fields_for :option_values, current_company.option_values.new, child_index: Time.now.to_i do |value_form|
        render turbo_stream: turbo_stream.append("option_values", partial: "option_value_fields", locals: { f: value_form })
      end
    end
  end

  def destroy
    @option_type.destroy
    redirect_to option_types_path, notice: "Tipo de opción eliminado exitosamente."
  end

  private

  def option_types_params
    params.require(:option_type).permit(
      :name, option_values_attributes: [:id, :name, :company_id, :_destroy]
    )
  end

  def set_option_type
    @option_type = current_company.option_types.find(params[:id])
  end
end
