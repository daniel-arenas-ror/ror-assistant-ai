class PageLayoutsController < ApplicationController
  def index
    @page_layouts = current_company.page_layouts.draft.order(created_at: :desc)
  end
end
