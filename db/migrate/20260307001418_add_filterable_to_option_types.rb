class AddFilterableToOptionTypes < ActiveRecord::Migration[8.1]
  def change
    add_column :option_types, :filterable, :boolean, default: false, null: false
  end
end
