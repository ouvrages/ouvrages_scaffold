# encoding: utf-8

require 'rails/generators/resource_helpers'

module Ouvrages
  module Generators
    class LocalesGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      source_root File.expand_path('../templates', __FILE__)

      argument :locales, :type => :array, :default => %w( en fr ), :banner => "locale"
      
      def create_locale_files
        require 'httparty'
        
        locales.each do |locale|
          @locale = locale
          template "#{locale}.yml", locale_filename(locale)
        end
      end
      
      protected

      def locale_filename(locale)
        File.join('config/locales', "#{singular_table_name}.#{locale}.yml")
      end
      
      def columns
        begin
          excluded_column_names = %w[]
          class_name.constantize.columns.reject{|c| excluded_column_names.include?(c.name) }.collect{|c| ::Rails::Generators::GeneratedAttribute.new(c.name, c.type)}
        rescue NoMethodError
          class_name.constantize.fields.collect{|c| c[1]}.reject{|c| excluded_column_names.include?(c.name) }.collect{|c| ::Rails::Generators::GeneratedAttribute.new(c.name, c.type.to_s)}
        end
      end
      
      attr_reader :locale, :translated, :gender

      def fetch_translation(string)
        Rails.cache.fetch(["translation", string]) do
          url = "http://api.wordreference.com/0.8/505fc/json/en#{locale}/#{URI.escape(string)}"
          response = HTTParty.get(url)
          JSON.parse(response.body)
        end
      end
      
      def translate(string)
        result = case locale
        when "en"
          case string
          when "Id" then "ID"
          when "Created at" then "Creation date"
          when "Updated at" then "Last update"
          else ""
          end
        when "fr"
          case string
          when "Id" then "Identifiant"
          when "Created at" then "Date de création"
          when "Updated at" then "Dernière mise à jour"
          else ""
          end
        else
          raise "Unknown locale: #{locale.inspect}"
        end
        result.force_encoding('ASCII-8BIT') # template is loaded as ASCII so it throws and incompatibility error
      end
      
      def plural(string)
        string.pluralize
      end
      
      def capitalize_first_letter(string)
        if string.present?
          string[0].capitalize + string[1..-1]
        else
          ""
        end
      end
      
      def grammar(locale, base, hint = nil)
        case locale.to_s
        when "code"
          base
        when "en"
          base.gsub('_', ' ')
        else
          value = I18n.t("grammar.#{base}", :default => "", :locale => locale)
          if value.blank?
            value = ask("#{base.inspect} in #{locale}#{" (#{hint})" if hint.present?}:")
            I18n.backend.store_translations(locale, {"grammar" => {base => value}})
          end
          value.force_encoding('ASCII-8BIT')
        end
      end
      
      def resource(locale = @locale)
        grammar(locale, singular_table_name)
      end
      
      def resources(locale = @locale)
        grammar(locale, plural_table_name)
      end
      
      def the_resource(locale = @locale)
        base = "the_#{resource(:code)}"
        grammar(locale, base)
      end
      
      def of_resource(locale = @locale)
        base = "of_#{resource(:code)}"
        grammar(locale, base, "as in 'modification of XXX named YYY'")
      end
      
      def start_with_vowel?
        %w(a e i o u ).include?(singular_table_name[0])
      end
      
      def a_resource(locale = @locale)
        if start_with_vowel?
          base = "an_#{resource(:code)}"
        else
          base = "a_#{resource(:code)}"
        end
        grammar(locale, base)
      end
      
      def resource_gender(locale = @locale)
        grammar(locale, "#{resource(:code)}_gender", "n|m|f")
      end
      
      def grammar_values
        %w( resource resources a_resource the_resource of_resource resource_gender ).map do |name|
          [send(name, :code), send(name)]
        end
      end
      
      def gender_select(values)
        values[resource_gender.to_sym]
      end
      
    end
  end
end
