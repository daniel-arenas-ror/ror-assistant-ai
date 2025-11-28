class AssistantsController < ApplicationController
  before_action :load_assistant, only: [:show, :edit, :update]

  def show
  end

  def edit

  end

  def update
    if @assistant.update!(assistant_params)
      respond_to do |format|
        format.html { redirect_to edit_assistant_path(@product), notice: "Assitant was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def assistant_params
    params.require(:assistant).permit(
      :name,
      :instructions,
      :assistant_id,
      :scrapping_instructions
    )
  end

  def load_assistant
    @assistant = current_company.assistants.find_by_slug(params[:id])
  end
end
