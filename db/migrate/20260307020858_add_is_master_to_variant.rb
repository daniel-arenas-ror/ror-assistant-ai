class AddIsMasterToVariant < ActiveRecord::Migration[8.1]
  def change
    add_column :variants, :is_master, :boolean, default: false, null: false
  end
end
