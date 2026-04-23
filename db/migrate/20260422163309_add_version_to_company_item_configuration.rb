class AddVersionToCompanyItemConfiguration < ActiveRecord::Migration[8.1]
  def change
    add_column :company_item_configurations, :versions, :integer, default: 0
  end
end
