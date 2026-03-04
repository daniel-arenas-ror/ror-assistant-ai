class CompanyController < ApplicationController
  def edit
  end

  def update
    if current_company.update(company_params)
      redirect_to edit_company_path, notice: "Company updated successfully."
    else
      flash.now[:alert] = current_company.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :icon)
  end
end
