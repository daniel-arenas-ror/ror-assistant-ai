ActiveAdmin.register User do
  permit_params :email, :company_id, :password, :password_confirmation

  form do |f|
    f.inputs do
      f.input :email
      f.input :company
      f.input :password
      f.input :password_confirmation
    end
  
    f.actions
  end
end
