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

    <%= @seo_check ? @seo_view : "" %>

  end

  ## FORM

  form html: { multipart: true } do |f|
    f.inputs '' do
      <%= @form_inputs %>
    end

    <%= @seo_check ? @seo_form : "" %>

    f.actions
  end
end
