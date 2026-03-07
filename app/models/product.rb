class Product < ApplicationRecord
  belongs_to :company
  has_many :variants, dependent: :destroy
  has_many :category_products, dependent: :destroy
  has_many :categories, through: :category_products
  has_many :product_option_types, dependent: :destroy
  has_many :option_types, through: :product_option_types

  slug :title_for_slug

  accepts_nested_attributes_for :product_option_types, allow_destroy: true
  accepts_nested_attributes_for :variants, allow_destroy: true

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 200]
    attachable.variant :medium, resize_to_limit: [450, 600]
    attachable.variant :large, resize_to_limit: [900, 1200]
  end

  after_save :update_master_variant

  def update_master_variant
    variants.find_or_create_by(is_master: true, company_id: company_id) do |variant|
      variant.sku   = slug 
      variant.price = price
    end
  end

  def title_for_slug
    "#{name}-#{id}".parameterize
  end

  def embed_input_with_img
    embed_input + "\n" + "url_images: #{url_images}"
  end

  def embed_input
    <<~EOS
      name: #{name}
      code: #{code}
      url: #{url}
      price: #{price}
      description: #{description}
      amenities: #{amenities}
      location: #{location}
    EOS
  end

  def raw_update!(attributes)
    conn = ActiveRecord::Base.connection.raw_connection

    sql = <<-SQL
      UPDATE products
      SET embedding = $1
      WHERE id = $2
      RETURNING id;
    SQL

    conn.exec_params(sql, [attributes[:embedding], id])
  end
end
