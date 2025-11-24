class UpdateTableRealEstateName < ActiveRecord::Migration[8.1]
  def change
    rename_table :real_estates, :products
  end
end
