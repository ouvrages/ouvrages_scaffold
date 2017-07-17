class <%= migration_class_name %> < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  def up
    create_table :<%= table_name %> do |t|
      t.timestamps
<% attributes.each do |attribute| -%>
<% next if attribute.localized? -%>
<% if attribute.type == :image -%>
      t.string :<%= attribute.name %>_uid
      t.string :<%= attribute.name %>_name
<% elsif attribute.type == :rich_text -%>
      t.text :<%= attribute.name %>
<% elsif attribute.type == :belongs_to or attribute.foreign_key? -%>
      t.integer :<%= attribute.name %>_id
<% else -%>
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>
<% end -%>
    end
<% attributes.select { |attr| attr.type == :belongs_to }.each do |attribute| -%>
    add_index :<%= table_name %>, :<%= attribute.name %>_id
<% end -%>
<% attributes.each do |attribute| -%>
<% if attribute.has_index? -%>
    add_index :<%= table_name %>, :<%= attribute.name %>
<% end -%>
<% if attribute.has_uniq_index? -%>
    add_index :<%= table_name %>, :<%= attribute.name %>, unique: true
<% end -%>
<% end -%>
<% if localized_attributes? -%>
    <%= class_name %>.create_translation_table! <%= localized_attributes.map { |attr| ":#{attr.name} => :#{attribute_type(attr.type)}" }.join(", ") %>
<% end -%>
  end

  def down
    drop_table :<%= table_name %>
<% if localized_attributes? -%>
    <%= class_name %>.drop_translation_table!
<% end -%>
  end
end
