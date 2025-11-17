ActiveAdmin.register RealEstate do

  index do
    selectable_column
    id_column
    column :company
    column :name
    column :code
    column :url
    column :price

    actions
  end
end
