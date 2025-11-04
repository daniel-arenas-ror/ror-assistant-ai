ActiveAdmin.register Conversation do

  show do
    attributes_table_for(resource) do
      row :id
      row :lead
      row :meta_data
    end

    panel "Messages" do
      table_for conversation.messages.ordered do
        column :id
        column :role
        column :content
        column :meta_data
      end
    end

    active_admin_comments_for(resource)
  end
end
