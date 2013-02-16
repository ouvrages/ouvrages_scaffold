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
            url = "http://api.wordreference.com/0.8/505fc/json/enfr/#{URI.escape(english)}"
            response = HTTParty.get(url)
            data = JSON.parse(response.body)
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
      attr_reader :locale, :translated, :gender
      
      def translate(string)
        string
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
