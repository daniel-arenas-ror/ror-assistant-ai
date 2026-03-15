class AddLabelToOptionValue < ActiveRecord::Migration[8.1]
  def change
    add_column :option_values, :label, :string
  end
end
