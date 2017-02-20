require 'ouvrages_generated_attribute'
require 'rails/generators/resource_helpers'

module Ouvrages
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => "Controller"

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      class_option :orm, :banner => "NAME", :type => :string, :required => true, :desc => "ORM to generate the controller for"
      class_option :show, :type => :boolean, :default => false, :desc => "Generate show action"
      class_option :json, :type => :boolean, :default => false, :desc => "Generate action with json"
      class_option :singleton, :type => :boolean, :default => false
      class_option :blocks, type: :boolean, default: false, desc: "Add blocks"
      class_option :admin, type: :boolean, default: false, :desc => "Enable admin namespace"

      def create_controller_files
        if admin_enabled?
          template "controller.rb", File.join('app/controllers/admin', class_path, "#{controller_file_name}_controller.rb")
        else
          template "controller.rb", File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
        end
      end

      protected

      def admin_enabled?
        Rails.application.config.admin_enable
      end

      def blocks?
        options[:blocks]
      end

      def singleton?
        options[:singleton]
      end

      def parse_attributes!
        self.attributes = (attributes || []).map do |attr|
          Rails::Generators::OuvragesGeneratedAttribute.parse(attr)
        end
      end
    end
  end
end
