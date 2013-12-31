require 'rails/generators'

module Ouvrages
  module Generators
    class ScaffoldGenerator < ::Rails::Generators::NamedBase
      class_option :locales, :type => :array, :default => %w( en fr ), :desc => "Locales to generate"

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
        invoke "ouvrages:locales", [name, "--locales=#{options[:locales].join(",")}"]
      end
    end
  end
end
