class AddPositionTo<%= table_name.capitalize %> < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  def up
    add_column :<%= table_name %>, :position, :integer
    add_index :<%= table_name %>, :position
  end

  def down
    remove_column :<%= table_name %>, :position, :integer
    remove_index :<%= table_name %>, :position
  end
end
