ActiveAdmin.register Tool do
  permit_params :name, :description, :function

  index do
    selectable_column
    id_column
    column :name
    column :description

    actions
  end
end