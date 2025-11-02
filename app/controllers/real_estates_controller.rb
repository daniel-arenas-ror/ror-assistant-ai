class RealEstatesController < ApplicationController
  before_action :set_real_estate, only: [:edit, :update]

  def index
    @real_estates = current_company.real_estates
  end

  def new
    @real_estate = current_company.real_estates.new
  end

  def create
    @real_estate = current_company.real_estates.build(real_estate_params)

    if @real_estate.save
      respond_to do |format|
        format.html { redirect_to real_estates_path(@real_estate), notice: "Real Estate was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @real_estate.update(real_estate_params)
      respond_to do |format|
        format.html { redirect_to real_estates_path, notice: "Real Estate was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Real Estate was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def scrape
    @real_estate = RealEstate.find(params[:id])
    ScraperService.update(@real_estate)
    redirect_to @real_estate, notice: "Data updated successfully!"
  end

  private

  def real_estate_params
    params.require(:real_estate).permit(
      :name,
      :code,
      :url,
      :url_images,
      :description,
      :amenities,
      :location
    )
  end

  def set_real_estate
    @real_estate = current_company.real_estates.find(params[:id])
  end

end