require 'ouvrages_generated_attribute'
require 'rails/generators'

module Ouvrages
  module Generators
    class ViewsGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      argument :controller_path,    :type => :string, :required => false
      argument :model_name,         :type => :string, :required => false
      argument :layout,             :type => :string, :default => "application",
                                    :banner => "Specify application layout"

      class_option :show, :type => :boolean, :default => false, :desc => "Generate show action"
      class_option :singleton, :type => :boolean, :default => false
      class_option :blocks, type: :boolean, default: false, desc: "Add blocks"
      class_option :admin, type: :boolean, default: false, :desc => "Enable admin namespace"
      class_option :sortable, type: :boolean, default: false, desc: "Sortable list"

      def initialize(args, *options)
        super(args, *options)
        initialize_views_variables
      end

      def copy_views
        generate_views
      end

      def add_to_navbar
        return false unless File.exists?("app/views/layouts/_admin_menu.html.haml")

        if admin_enabled?
          if singleton?
            append_file "app/views/layouts/_admin_menu.html.haml", "%li= link_to t(\"navigation.#{plural_table_name}\"), edit_admin_#{singular_table_name}_path(#{ model_name }.instance) if can? :update, #{ model_name }.instance\n"
          else
            append_to_file "app/views/layouts/_admin_menu.html.haml", "= render 'admin/#{plural_resource_name}/nav'\n"
          end
        else
          if singleton?
            append_file "app/views/layouts/_admin_menu.html.haml", "%li= link_to t(\"navigation.#{plural_table_name}\"), edit_#{singular_table_name}_path(#{ model_name }.instance) if can? :update, #{ model_name }.instance\n"
          else
            append_to_file "app/views/layouts/_admin_menu.html.haml", "= render '#{plural_resource_name}/nav'\n"
          end
        end
      end

      protected

      def path
        if admin_enabled?
          'app/views/admin'
        else
          'app/views'
        end
      end

      def admin_enabled?
        Rails.application.config.admin_enable
      end

      def show?
        options[:show]
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

      def parse_attributes!
        self.attributes = (attributes || []).map do |attr|
          Rails::Generators::OuvragesGeneratedAttribute.parse(attr)
        end
      end

      def initialize_views_variables
        @base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(name)
        @controller_routing_path = @controller_file_path.gsub(/\//, '_')
        @model_name = @controller_class_nesting + "::#{@base_name.singularize.camelize}" unless @model_name
        @model_name = @model_name.camelize
      end

      def controller_routing_path
        @controller_routing_path
      end

      def singular_controller_routing_path
        @controller_routing_path.singularize
      end

      def model_name
        @model_name
      end

      def plural_model_name
        @model_name.pluralize
      end

      def resource_name
        @model_name.demodulize.underscore
      end

      def plural_resource_name
        resource_name.pluralize
      end

      def extract_modules(name)
        modules = name.include?('/') ? name.split('/') : name.split('::')
        name    = modules.pop
        path    = modules.map { |m| m.underscore }
        file_path = (path + [name.pluralize.underscore]).join('/')
        nesting = modules.map { |m| m.camelize }.join('::')
        [name, path, file_path, nesting, modules.size]
      end

      def generate_views
        views = {
          "edit.html.#{ext}"                  => File.join(path, @controller_file_path, "edit.html.#{ext}"),
          "#{form_builder}_form.html.#{ext}"  => File.join(path, @controller_file_path, "_form.html.#{ext}"),
          "_nav.html.#{ext}"                  => File.join(path, @controller_file_path, "_nav.html.#{ext}"),
        }

        unless singleton?
          views.merge!({
            "index.html.#{ext}" => File.join(path, @controller_file_path, "index.html.#{ext}"),
            "new.html.#{ext}" => File.join(path, @controller_file_path, "new.html.#{ext}"),
          })
        end

        if show?
          views.merge!({
            "show.html.#{ext}" => File.join(path, @controller_file_path, "show.html.#{ext}"),
          })
        end

        options.engine == generate_erb(views)
      end

      def generate_erb(views)
        views.each do |template_name, output_path|
          template template_name, output_path
        end
      end

      def ext
        ::Rails.application.config.generators.options[:rails][:template_engine] || :erb
      end

      def form_builder
        ''
      end

      def field_type(attribute)
        case attribute.type
        when :rich_text
          :rich_text_field
        when :image
          :image_field
        else
          attribute.field_type
        end
      end
    end
  end
end
