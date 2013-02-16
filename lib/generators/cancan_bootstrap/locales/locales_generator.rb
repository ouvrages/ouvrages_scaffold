# encoding: utf-8

require 'rails/generators/resource_helpers'

module CancanBootstrap
  module Generators
    class LocalesGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      source_root File.expand_path('../templates', __FILE__)

      argument :locales, :type => :array, :default => %w( en fr ), :banner => "locale"
      
      def create_locale_files
        require 'httparty'
        
        locales.each do |locale|
          @locale = locale
          english = singular_table_name.humanize.downcase
          @gender = :m
          @translated = english
          if locale != "en"
            data = fetch_translation(english)
            if data["term0"]
              translations = data["term0"]["PrincipalTranslations"] || data["term0"]["Entries"]
              translation = translations["0"]["FirstTranslation"]
              @translated = translation["term"]
              if translation["POS"] == "nf"
                @gender = :f
              end
            end
          end
          template "#{locale}.yml", File.join('config/locales', "#{singular_table_name}.#{locale}.yml")
        end
      end
      
      protected
      
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
          else string.humanize
          end
        when "fr"
          case string
          when "Id" then "Identifiant"
          when "Created at" then "Date de création"
          when "Updated at" then "Dernière mise à jour"
          else translate_string(string, string.humanize)
          end
        else
          raise "Unknown locale: #{locale.inspect}"
        end
        result.force_encoding('ASCII-8BIT') # template is loaded as ASCII so it throws and incompatibility error
      end
      
      def translate_string(string, default = string)
        data = fetch_translation(string)
        if data["term0"]
          translations = data["term0"]["PrincipalTranslations"] || data["term0"]["Entries"]
          translation = translations["0"]["FirstTranslation"]
          translated = translation["term"]
          translated
        else
          default
        end
      end
      
      def plural(string)
        string.pluralize
      end
      
      def capitalize_first_letter(string)
        string[0].capitalize + string[1..-1]
      end
      
      def gender_mf(m, f)
        gender == :f ? f : m
      end
      
      def indefinite_article
        case locale
        when "en"
          if %w(a e i o u ).include?(translated[0])
            "an"
          else
            "a"
          end
        when "fr"
          if gender == :f
            "une"
          else
            "un"
          end
        else
          raise "Unknown locale: #{locale.inspect}"
        end
      end

      def definite_article
        case locale
        when "en"
          "the"
        when "fr"
          if gender == :f
            "la"
          else
            "le"
          end
        else
          raise "Unknown locale: #{locale.inspect}"
        end
      end
    end
  end
end
