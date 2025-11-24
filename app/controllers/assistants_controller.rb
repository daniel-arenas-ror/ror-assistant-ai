class AssistantsController < ApplicationController
  before_action :load_assistant, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update

  end

  private

  def assistant_params
    params.require(:assistant).permit(:name, :description, :avatar_url)
  end

  def load_assistant
    @assistant = current_company.assistants.find_by_slug(params[:id])
  end
end
