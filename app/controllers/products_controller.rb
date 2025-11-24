class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update]

  def index
    @products = current_company.products
  end

  def new
    @product = current_company.products.new
  end

  def create
    @product = current_company.products.build(product_params)

    if @product.save
      respond_to do |format|
        format.html { redirect_to edit_product_path(@product), notice: "Product was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      respond_to do |format|
        format.html { redirect_to edit_product_path(@product), notice: "Product was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def scrape
    @product = Product.find(params[:id])
    AIService::ScrapeProduct.new(product: @product).process
    AIService::OpenaiService::Embedding.new(product: @product).generate_embedding

    redirect_to edit_product_path(@product), notice: "Data updated successfully!"
  end

  private

  def product_params
    params.require(:product).permit(
      :name,
      :code,
      :url,
      :url_images,
      :description,
      :amenities,
      :location
    )
  end

  def set_product
    @product = current_company.products.find(params[:id])
  end

end