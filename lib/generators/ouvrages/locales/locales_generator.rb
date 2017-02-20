# encoding: utf-8

require 'rails/generators/resource_helpers'

module Ouvrages
  module Generators
    class LocalesGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      source_root File.expand_path('../templates', __FILE__)

      class_option :locales, :type => :array, :default => %w( en fr ), :desc => "Locales to generate"
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      class_option :singleton, :type => :boolean, :default => false
      class_option :show, :type => :boolean, :default => false
      class_option :blocks, type: :boolean, default: false, desc: "Add blocks"
      class_option :admin, type: :boolean, default: false, :desc => "Enable admin namespace"

      def create_locale_files
        locales.each do |locale|
          @locale = locale
          template "models/#{locale}.yml", "config/locales/#{singular_table_name}.#{locale}.yml"
          if admin_enabled?
            template "admin/#{locale}.yml", "config/locales/admin/#{singular_table_name}.#{locale}.yml"
          else
            template "#{locale}.yml", "config/locales/#{plural_table_name}.#{locale}.yml"
          end
        end
      end

      protected

      def admin_enabled?
        Rails.application.config.admin_enable
      end

      def blocks?
        options[:blocks]
      end

      def show?
        options[:show]
      end

      def singleton?
        options[:singleton]
      end

      def locales
        options[:locales]
      end

      attr_reader :locale, :translated, :gender

      def translate(name, locale = @locale)
        value = I18n.t("activerecord.attributes.#{singular_table_name}.#{name}", :default => "", :locale => locale)

        if value.blank?
          value = case locale
          when "en"
            case name
            when "Id" then "ID"
            when "Created at" then "Creation date"
            when "Updated at" then "Last update"
            else ""
            end
          when "fr"
            yaml = YAML.load_file(File.expand_path('../dictionary.fr.yml', __FILE__))
            result = yaml[name] || ""
          else
            raise "Unknown locale: #{locale.inspect}"
          end
        end

        if value.blank?
          if locale == "en"
            value = ""
          else
            value = ask("#{name.inspect} in #{locale}:")
          end
        end

        I18n.backend.store_translations(locale, {"activerecord" => { "attributes" => { singular_table_name => { name => value }}}})
        value.force_encoding('ASCII-8BIT')
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

        if singleton?
          grammar_values = %w( resource the_resource of_resource resource_gender )
        else
          grammar_values = %w( resource resources a_resource the_resource of_resource resource_gender )
        end

        grammar_values.map do |name|
          [send(name, :code), send(name)]
        end
      end

      def gender_select(values)
        values[resource_gender.to_sym]
      end

    end
  end
end
