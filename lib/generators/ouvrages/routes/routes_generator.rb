require 'rails/generators'

module Ouvrages
  module Generators
    class RoutesGenerator < ::Rails::Generators::NamedBase
      def add_route
        route "resources :#{plural_table_name}"
      end
    end
  end
end
