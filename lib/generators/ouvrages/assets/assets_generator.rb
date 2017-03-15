require 'rails/generators/resource_helpers'

module Ouvrages
  module Generators
    class AssetsGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path('../template', __FILE__)
      class_option :sortable, type: :boolean, default: false, desc: "Sortable list"


      def add_sortable_module
        if sortable?
          template "sortable_list.js", File.join("app/assets/javascripts", "modules/sortable_list/index.js")
        end
      end

      def append_manifest
        if sortable?
          append_file path, "//= require modules/sortable_list\n"
        end
      end

      protected

      def path
        if admin_enabled?
          'app/assets/javascripts/admin.js'
        else
          'app/assets/javascripts/application.js'
        end
      end

      def admin_enabled?
        Rails.application.config.admin_enable
      end

      def sortable?
        options[:sortable]
      end
    end
  end
end
