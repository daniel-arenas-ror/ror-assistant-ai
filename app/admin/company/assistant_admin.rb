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
end
