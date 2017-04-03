require 'ouvrages_generated_attribute'
require 'rails/generators/active_record/migration'

module Ouvrages
  module Generators
    class MigrationGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"
      class_option :sortable, type: :boolean, default: false, desc: "Sortable list"

      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def create_migration_files
        migration_template "migration.rb", "db/migrate/create_#{table_name}.rb"
      end

      def add_position_to_table
        migration_template "position.rb", "db/migrate/add_position_to_#{table_name}.rb" if sortable?
      end

      protected

      def sortable?
        options[:sortable]
      end

      def localized_attributes
        attributes.select { |attr| attr.localized? }
      end

      def localized_attributes?
        localized_attributes.any?
      end

      def parse_attributes!
        self.attributes = (attributes || []).map do |attr|
          Rails::Generators::OuvragesGeneratedAttribute.parse(attr)
        end
      end

      def attribute_type(type)
        case type
        when :rich_text
          :text
        else
          type
        end
      end
    end
  end
end
