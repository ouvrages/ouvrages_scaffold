require 'ouvrages_generated_attribute'
require 'rails/generators/active_record/migration'

module Ouvrages
  module Generators
    class MigrationGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"

      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def create_migration_files
        migration_template "migration.rb", "db/migrate/create_#{table_name}.rb"
      end

      protected

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
