class AddRelationToCompany < ActiveRecord::Migration[8.1]
  def change
      add_reference :variants, :company, null: false, foreign_key: true
      add_reference :option_types, :company, null: false, foreign_key: true
      add_reference :option_values, :company, null: false, foreign_key: true
      add_reference :variant_option_values, :company, null: false, foreign_key: true
  end
end
