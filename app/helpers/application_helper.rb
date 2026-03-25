module ApplicationHelper
  def common_currency_options
    Money::Currency.table.values
      .select { |c| c[:priority] && c[:priority] <= 100 }
      .map { |c| ["#{c[:iso_code]} (#{c[:symbol]})", c[:iso_code]] }
      .sort
  end

  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "layouts/flash"
  end

  def form_error_notification(object)
    if object.errors.any?
      tag.div class: "error-message" do
        object.errors.full_messages.to_sentence.capitalize
      end
    end
  end
end
