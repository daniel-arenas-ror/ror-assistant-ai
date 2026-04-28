class PageLayoutsController < ApplicationController
  def index
    @page_layouts = current_company.page_layouts.draft.order(created_at: :desc)
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def send_to_production

  end

  private

  def page_layout_params
    params.require(:page_layout).permit(
      :page_type,
      :meta_title,
      :path,
      :version,
      page_components_attributes: [
        :id,
        :component_type,
        :position,
        config: {}
      ]
    )
  end
end
