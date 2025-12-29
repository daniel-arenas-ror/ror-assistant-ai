class AssistantsController < ApplicationController
  before_action :load_assistant, only: [:show, :edit, :update]

  def show
  end

  def edit
    @assistant.assistant_files.build
  end

  def update
    if @assistant.update!(assistant_params)

      if !@assistant.use_openai?
        if virtual_file_params.present?
          virtual_file_params[:uploaded_files].each do |uploaded_file|

            next if uploaded_file == ""

            p " uploaded_file ==> #{uploaded_file} "
            #debugger

            resource_name = AIService::GeminiService::File.new(ENV.fetch('GEMINI_API_KEY', '')).upload_uploaded_file(uploaded_file)
            @assistant.assistant_files.create!(
              resource_name: resource_name,
              file_name: uploaded_file.original_filename
            )
          end
        end
      end

      AIService::OpenaiService::Assistant.new(assistant: @assistant).process if @assistant.use_openai?

      respond_to do |format|
        format.html { redirect_to edit_assistant_path(@assistant), notice: "Assitant was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def virtual_file_params
    params.require(:assistant).permit(uploaded_files: [])
  end

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
