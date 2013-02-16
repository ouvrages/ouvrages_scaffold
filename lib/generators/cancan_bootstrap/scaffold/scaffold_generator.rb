require 'rails/generators'

module CancanBootstrap
  module Generators
    class ScaffoldGenerator < ::Rails::Generators::NamedBase
      def generate_controller
        invoke "cancan_bootstrap:controller"
      end
      
      def generate_routes
        invoke "cancan_bootstrap:routes"
      end
      
      def generate_views
        invoke "cancan_bootstrap:views"
      end

      def generate_locales
        invoke "cancan_bootstrap:locales"
      end
    end
  end
end
