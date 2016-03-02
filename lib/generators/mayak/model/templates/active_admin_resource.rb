ActiveAdmin.register <%= @name.camelize %> do

  permit_params <%= @permit_params %>

  ## INDEX

  index download_links: false do
    selectable_column
    id_column
    <%= @index_columns %>
    actions
  end

  ## SHOW

  show do
    attributes_table do
      <%= @view_rows %>
    end
  end

  ## FORM

  form html: { multipart: true } do |f|
    f.inputs '' do
      <%= @form_inputs %>
    end
  end
end
