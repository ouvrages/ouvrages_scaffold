require 'rails/generators/resource_helpers'

module Cancan
  module Generators
    class ScaffoldControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => "Controller"

      class_option :orm, :banner => "NAME", :type => :string, :required => true,
                         :desc => "ORM to generate the controller for"

      class_option :http, :type => :boolean, :default => false,
                          :desc => "Generate controller with HTTP actions only"

      def create_controller_files
        template "controller.rb", File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
      end
    end
  end
end
