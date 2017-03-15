require 'rails/generators'

module Ouvrages
  module Generators
    class ScaffoldGenerator < ::Rails::Generators::NamedBase

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      class_option :locales, :type => :array, :default => %w( en fr ), :desc => "Locales to generate"
      class_option :show, :type => :boolean, :default => false, :desc => "Generate show action"
      class_option :model, :type => :boolean, :default => true, :desc => "Generate model"
      class_option :migration, :type => :boolean, :default => true, :desc => "Generate migration"
      class_option :singleton, :type => :boolean, :default => false, :desc => "Create singleton model"

      def generate_migration
        invoke "ouvrages:migration" if migration?
      end

      def generate_model
        invoke "ouvrages:model" if model?
      end

      def generate_controller
        invoke "ouvrages:controller"
      end

      def generate_routes
        invoke "ouvrages:routes"
      end

      def generate_views
        invoke "ouvrages:views"
       end

      def generate_locales
        invoke "ouvrages:locales"
      end

      def generate_assets
        invoke "ouvrages:assets"
      end

      private

      def model?
        options[:model]
      end

      def migration?
        options[:migration]
      end
    end
  end
end
