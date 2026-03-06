# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    description "An image attached to a product with multiple size variants."

    field :id, String, null: false
    field :url, String, null: false
    field :thumb_url, String, null: true
    field :medium_url, String, null: true
    field :large_url, String, null: true

    def id
      object&.id
    end

    def url
      Rails.application.routes.url_helpers.rails_blob_url(object) if object
    end

    def thumb_url
       Rails.application.routes.url_helpers.rails_blob_url(object.variant(:thumb)) if object
    end

    def medium_url
      Rails.application.routes.url_helpers.rails_blob_url(object.variant(:medium)) if object
    end

    def large_url
      Rails.application.routes.url_helpers.rails_blob_url(object.variant(:large)) if object
    end
  end
end
