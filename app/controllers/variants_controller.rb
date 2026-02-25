class VariantsController < ApplicationController
  def purge_image
    @variant = Variant.find(params[:id])
    image = @variant.images.find(params[:image_id])
    
    image.purge
    
    respond_to do |format|
      format.html { redirect_to edit_variant_path(@variant), notice: "Image deleted." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(image) }
    end
  end
end
