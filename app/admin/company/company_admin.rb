ActiveAdmin.register Company do
  permit_params :name, :email, :phone, :ai_source

end
