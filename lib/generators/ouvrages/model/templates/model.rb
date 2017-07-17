# Generated with: <%= command_line %>
class <%= name.camelcase %> < ApplicationRecord
<% if activable? -%>
  scope :active, -> { where(active: true) }
<% end -%>
<% if sortable? -%>
  scope :sorted_by_position, -> { order(:position) }
<% end -%>
<% if singleton? -%>
  def self.instance
    first || new
  end
<% end -%>
<% if image_attributes.any? -%>
  dragonfly_accessor <%= image_attributes.map { |attr| ":#{attr.name}" }.join(", ") %>
<% end -%>
<% if localized_attributes? -%>
  translates <%= localized_attributes.map { |attr| ":#{attr.name}" }.join(", ") %>
  globalize_accessors
<% end -%>
<% belongs_to_attributes.each do |attr| -%>
  belongs_to :<%= attr.name %>
<% end -%>
<% if blocks? -%>
  has_blocks([])
<% end -%>
  def to_label
    raise "TODO: set to_label"
  end
end
