class CompanyController < ApplicationController
  def edit
    current_company.build_default_payment_setting
  end

  def update
    ActiveRecord::Base.transaction do
      if current_company.update(company_params.except(:item_configurations))
        update_item_configurations
        redirect_to edit_company_path, notice: "Company updated successfully."
      else
        flash.now[:alert] = current_company.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :icon,
      :currency,
      item_configurations: [:name, :value],
      payment_setting_attributes: [:id, :provider, :api_key, :secret]
    )
  end

  def update_item_configurations
    item_configs_params = company_params[:item_configurations]
    return if item_configs_params.blank?

    item_configs_params.each_value do |cfg|
      name  = cfg[:name] || cfg["name"]
      value = cfg[:value] || cfg["value"]

      next if name.blank? || value.blank?

      record = current_company.company_item_configurations.find_or_initialize_by(name: name)
      record.value = value
      record.save!
    end
  end
end
