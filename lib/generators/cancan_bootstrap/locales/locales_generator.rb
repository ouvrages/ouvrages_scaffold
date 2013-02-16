require 'rails/generators/resource_helpers'

module CancanBootstrap
  module Generators
    class LocalesGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      source_root File.expand_path('../templates', __FILE__)

      argument :locales, :type => :array, :default => I18n.available_locales.map(&:to_s), :banner => "field:type field:type"
      
      def create_locale_files
        locales.each do |locale|
          @locale = locale
          template "locale.yml", File.join('config/locales', "#{singular_table_name}.#{locale}.yml")
        end
      end
      
      protected
      def locale
        @locale
      end
      
      def translate(string)
        string
      end
    end
  end
end
