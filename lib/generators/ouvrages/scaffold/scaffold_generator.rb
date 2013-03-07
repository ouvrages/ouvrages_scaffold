require 'rails/generators'

module Ouvrages
  module Generators
    class ScaffoldGenerator < ::Rails::Generators::NamedBase
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
    end
  end
end
