require File.expand_path("../../../../ouvrages_generated_attribute", __FILE__)
require "rails/generators/model_helpers"

module Ouvrages
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ModelHelpers
      source_root File.expand_path('../templates', __FILE__)

      argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"
      class_option :singleton, type: :boolean, default: false , desc: "Create singleton model"
      class_option :blocks, type: :boolean, default: false, desc: "Add blocks"
      class_option :sortable, type: :boolean, default: false, desc: "Sortable list"
      class_option :activable, type: :boolean, default: false, desc: "Activable"

      def create_model_file
        template "model.rb", File.join("app", "models", file_path + ".rb")
      end

      protected

      def command_line
        "bundle exec rails generate ouvrages:scaffold #{ARGV.join(' ')}"
      end

      def parse_attributes!
        self.attributes = (attributes || []).map do |attr|
          Rails::Generators::OuvragesGeneratedAttribute.parse(attr)
        end
      end

      def activable?
        options[:activable]
      end

      def sortable?
        options[:sortable]
      end

      def blocks?
        options[:blocks]
      end

      def singleton?
        options[:singleton]
      end

      def image_attributes
        attributes.select { |attr| attr.type == :image }
      end

      def image_attributes?
        image_attributes.any?
      end

      def belongs_to_attributes
        attributes.select { |attr| attr.type == :belongs_to }
      end

      def localized_attributes
        attributes.select { |attr| attr.localized? }
      end

      def localized_attributes?
        localized_attributes.any?
      end
    end
  end
end
