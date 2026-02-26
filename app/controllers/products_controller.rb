class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :scrape]
  before_action :normalize_variant_selected_options, only: [:create, :update]

  def index
    @products = current_company.products
  end

  def new
    @product = current_company.products.new
    @product.variants.build(company: current_company) if @product.variants.empty?
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
    @product.variants.build(company: current_company) if @product.variants.empty?
  end

  def update
    p " product_params in update "
    p product_params
    p " ********** *********** ******** ********** "

    if @product.update(product_params)
      respond_to do |format|
        format.html { redirect_to edit_product_path(@product), notice: "Product was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def scrape
    AIService::ScrapeProduct.new(product: @product).process
    AIService::Embedding.new(product: @product).update_embedding!

    redirect_to edit_product_path(@product), notice: "Data updated successfully!"
  end

  private

  def normalize_variant_selected_options
    return unless params[:product] && params[:product][:variants_attributes]

    params[:product][:variants_attributes].each do |_idx, v_attrs|
      if v_attrs[:selected_option_values]
        v_attrs[:option_value_ids] = v_attrs.delete(:selected_option_values).values.reject(&:blank?)
      end
    end
  end

  def product_params
    params.require(:product).permit(
      :name,
      :code,
      :url,
      :url_images,
      :description,
      :amenities,
      :location,
      :price,
      variants_attributes: [
        :id, :sku, :price, :_destroy, :company_id, { option_value_ids: [] }, { selected_option_values: {} }, images: []
      ]
    )
  end

  def set_product
    @product = current_company.products.find(params[:id])
  end
end
