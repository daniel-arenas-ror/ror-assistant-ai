module Types
  class ProductType < Types::BaseObject
    description "A product belonging to a company."

    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :description, String, null: true
    field :price, Float, null: false
    field :code, String, null: true
    field :images, [Types::ImageType], null: true
    field :categories, [Types::CategoryType], null: false
    field :active, Boolean, null: false
    field :all_images, [Types::ImageType], null: true
    field :option_values, [Types::OptionValueType], null: true

    def all_images
      object.images + object.variants.flat_map(&:images) + object.product_option_values.flat_map(&:images)
    end
  end
end
