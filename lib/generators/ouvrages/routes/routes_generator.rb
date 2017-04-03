require 'rails/generators'

module Ouvrages
  module Generators
    class RoutesGenerator < ::Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      source_root File.expand_path('../templates', __FILE__)

      class_option :show, :type => :boolean, :default => false, :desc => "Generate show action"
      class_option :singleton, :type => :boolean, :default => false
      class_option :admin, type: :boolean, default: false, :desc => "Enable admin namespace"
      class_option :sortable, type: :boolean, default: false, desc: "Sortable list"

      def add_resource_route
        insert_into_file(path, resource_route, params)
        insert_into_file(path, sortable_route, params) if sortable?
      end

      protected

      def params
        options = {}
        if admin_enabled?
          options[:after] = "root to: 'dashboard#index'\n"
        else
          options[:after] = "Rails.application.routes.draw do\n"
        end
        options
      end

      def path
        if admin_enabled?
          "config/routes/admin.rb"
        else
          "config/routes.rb"
        end
      end

      def resource_route
        if singleton?
          singleton_route
        elsif show?
          show_route
        else
          standard_route
        end
      end

      def singleton_route
        if admin_enabled?
          "\nresources :#{plural_table_name}, only: [:edit, :update]\n"
        else
          "\n  resources :#{plural_table_name}, only: [:edit, :update]\n"
        end
      end

      def show_route
        if admin_enabled?
          "\nresources :#{plural_table_name}\n"
        else
          "\n  resources :#{plural_table_name}\n"
        end
      end

      def standard_route
        if admin_enabled?
          "\nresources :#{plural_table_name}, except: [:show]\n"
        else
          "\n  resources :#{plural_table_name}, except: [:show]\n"
        end
      end

      def sortable_route
        if admin_enabled?
          "\npost '/#{plural_table_name}/sort', to: '#{plural_table_name}#sort', as: :sort_#{plural_table_name}\n"
        else
          "\n  post '/#{plural_table_name}/sort', to: '#{plural_table_name}#sort', as: :sort_#{plural_table_name}\n"
        end
      end

      def singleton?
        options[:singleton]
      end

      def show?
        options[:show]
      end

      def sortable?
        options[:sortable]
      end

      def admin_enabled?
        Rails.application.config.admin_enable
      end
    end
  end
end
