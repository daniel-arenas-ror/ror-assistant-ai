class Category < ApplicationRecord
  slug :title_for_slug

  # Sub-categories (Men -> [Shoes, Shirts])
  has_many :sub_categories, class_name: "Category", 
                            foreign_key: "parent_id", 
                            dependent: :destroy
  
  # The parent (Shoes -> Men)
  belongs_to :parent_category, class_name: "Category", 
                               foreign_key: "parent_id", 
                               optional: true

  has_many :products

  # Helper to find "Root" categories (Men, Women, Kids)
  scope :roots, -> { where(parent_id: nil) }
  
  accepts_nested_attributes_for :sub_categories, allow_destroy: true

  def title_for_slug
    "#{name}".parameterize
  end
end
