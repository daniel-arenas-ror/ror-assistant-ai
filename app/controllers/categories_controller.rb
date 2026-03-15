class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = current_company.categories.roots.order(:name)
  end

  def show
  end

  def new
    @category = current_company.categories.new
  end

  def create
    @category = current_company.categories.new(category_params)
    if @category.save
      redirect_to edit_category_path(@category), notice: 'Category created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to edit_category_path(@category), notice: 'Category updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: 'Category removed.'
  end

  private

  def set_category
    @category = current_company.categories.find_by_slug(params[:id])
  end

  def category_params
      params.require(:category).permit(
        :name,
        :parent_id,
        images: [],
        sub_categories_attributes: [:id, :name, :company_id, :_destroy]
      )
  end
end
