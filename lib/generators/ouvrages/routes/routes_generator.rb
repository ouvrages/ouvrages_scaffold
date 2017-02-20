require 'rails/generators'

module Ouvrages
  module Generators
    class RoutesGenerator < ::Rails::Generators::NamedBase
      class_option :show, :type => :boolean, :default => false, :desc => "Generate show action"
      class_option :singleton, :type => :boolean, :default => false
      class_option :admin, type: :boolean, default: false, :desc => "Enable admin namespace"

      def add_route
        if admin_enabled?
          if options[:singleton]
            append_to_file "config/routes/admin.rb", "\nresources :#{plural_table_name}, only: [:edit, :update]"
          elsif options[:show]
            append_to_file "config/routes/admin.rb", "\nresources :#{plural_table_name}\n"
          else
            append_to_file "config/routes/admin.rb", "\nresources :#{plural_table_name}, except: [:show]"
          end
        else
          if options[:singleton]
            insert_into_file "config/routes.rb", "\n  resources :#{plural_table_name}, only: [:edit, :update]", after: "Rails.application.routes.draw do\n"
          elsif options[:show]
            insert_into_file "config/routes.rb", "\n  resources :#{plural_table_name}\n", after: "Rails.application.routes.draw do\n"
          else
            insert_into_file "config/routes.rb", "\n  resources :#{plural_table_name}, except: [:show]", after: "Rails.application.routes.draw do\n"
          end
        end
      end

      protected

      def admin_enabled?
        Rails.application.config.admin_enable
      end
    end
  end
end
