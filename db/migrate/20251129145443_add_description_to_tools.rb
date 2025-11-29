class AddDescriptionToTools < ActiveRecord::Migration[8.1]
  def change
    add_column :tools, :description, :text, default: ""
  end
end
