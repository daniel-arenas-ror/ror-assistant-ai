class AssistantsController < ApplicationController
  before_action :load_assistant, only: [:show, :edit, :update]

  def show
  end

  def edit
    @assistant.assistant_files.build
  end

  def update
    if @assistant.update!(assistant_params)
      AIService::OpenaiService::Assistant.new(assistant: @assistant).process if @assistant.use_openai?

      respond_to do |format|
        format.html { redirect_to edit_assistant_path(@assistant), notice: "Assitant was successfully updated." }
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
      :role,
      :task,
      :context,
      :reasoning,
      :outputs,
      :conditions,
      :assistant_id,
      :temperature,
      :top_p,
      :scrapping_instructions,
      assistant_tools_attributes: [:id, :tool_id, :_destroy],
      assistant_files_attributes: [:id, :resource_name, :file_name, :_destroy]
    )
  end

  def load_assistant
    @assistant = current_company.assistants.find_by_slug(params[:id])
  end
end
