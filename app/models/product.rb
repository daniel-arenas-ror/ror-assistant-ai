class Product < ApplicationRecord
  belongs_to :company
  has_many :variants, dependent: :destroy
  has_many :option_types, -> { distinct }, through: :variants
  has_many :category_products, dependent: :destroy
  has_many :categories, through: :category_products

  slug :title_for_slug

  accepts_nested_attributes_for :variants, allow_destroy: true

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 200]
    attachable.variant :medium, resize_to_limit: [450, 600]
    attachable.variant :large, resize_to_limit: [900, 1200]
  end

  def title_for_slug
    "#{name}".parameterize
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
