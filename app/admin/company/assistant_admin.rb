ActiveAdmin.register Assistant do
  permit_params :name, :assistant_id, :company_id, :instructions, :scrapping_instructions

  form do |f|
    f.inputs do
      f.input :name
      f.input :assistant_id
      f.input :company
      f.input :instructions
      f.input :scrapping_instructions
    end
  
    f.actions
  end

   index do
    selectable_column
    id_column
    column :company
    column :name

    actions
  end
end
