class AddActiveTo<%= table_name.capitalize %> < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  def up
    add_column :<%= table_name %>, :active, :boolean, default: true
  end

  def down
    remove_column :<%= table_name %>, :active, :boolean
  end
end
