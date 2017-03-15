require 'rails/generators'

module Ouvrages
  module Generators
    class SetupGenerator < ::Rails::Generators::Base

      class_option :admin, type: :boolean, default: false

      def install_gems
        if File.exists?("Gemfile")
          gem 'haml-rails'
          gem 'sorcery'
          gem 'cancancan'
          gem 'bootstrap-sass', '~> 3.3.6'
          gem 'bootstrap_form'
          gem 'jquery-rails'
          gem 'sortable-rails'
        else
          append_to_file ENV['BUNDLE_GEMFILE'] do
<<-EOF
gem 'haml-rails'
gem 'sorcery'
gem 'cancancan'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootstrap_form'
gem 'jquery-rails'
gem 'sortable-rails'
EOF
          end
        end
      end

      def handle_gem_generators
        #generate "sorcery:install"
        #generate "cancan:ability"
      end

      def handle_stylesheets
        if options[:admin]
          remove_file 'app/assets/stylesheets/application.css'
          create_file 'app/assets/stylesheets/application.sass'
          create_file 'app/assets/stylesheets/admin.sass'
          append_to_file 'app/assets/stylesheets/admin.sass' do
<<-EOF
@import 'bootstrap-sprockets'
@import 'bootstrap'
EOF
          end
        else
          remove_file 'app/assets/stylesheets/application.css'
          create_file 'app/assets/stylesheets/application.sass'
          append_to_file 'app/assets/stylesheets/application.sass' do
<<-EOF
@import 'bootstrap-sprockets'
@import 'bootstrap'
EOF
          end
        end
      end

      def handle_javascripts
        gsub_file 'app/assets/javascripts/application.js', '//= require_tree .', ''
        if options[:admin]
          create_file 'app/assets/javascripts/admin.js'
          append_to_file 'app/assets/javascripts/admin.js' do
<<-EOF
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require sortable-rails-jquery
EOF
          end
        else
          append_to_file 'app/assets/javascripts/application.js' do
<<-EOF
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require sortable-rails-jquery
EOF
          end
        end
      end

      def create_admin_initializer

        if options[:admin]

          initializer "admin.rb" do
<<-EOF
Rails.application.config.admin_enable = true
Rails.application.config.assets.precompile += %w( admin.css admin.js )
EOF
          end
        else
          application "I18n.config.available_locales = [:en, :fr]"
          application "config.admin_enable = false"
        end
      end

      def create_admin_routes_file
        return false unless options[:admin]

        insert_into_file "config/routes.rb", after: "Rails.application.routes.draw do\n" do
<<-EOF
  namespace :admin do
    instance_eval(File.read(Rails.root.join("config/routes/admin.rb")))
  end
EOF
        end
        create_file "config/routes/admin.rb"
      end

      def create_menu_layouts
        create_file "app/views/layouts/_admin_menu.html.haml"
        create_file "app/views/layouts/_admin_menu_dropdown.html.haml" do
<<-EOF
%li.dropdown
  %a.dropdown-toggle{href: "#", data: {toggle: "dropdown"}}
    = title
    %span.caret
  %ul.dropdown-menu
    = content
EOF
        end
      end

      def rename_application_layouts
        remove_file 'app/views/layouts/application.html.erb'
        create_file 'app/views/layouts/application.html.haml'
        append_to_file 'app/views/layouts/application.html.haml' do
<<-EOF
%html
  %head
    %meta(content="text/html; charset=UTF-8" http-equiv="Content-Type")
    %title
      = content_for(:title)
    = csrf_meta_tags
    = stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload'
    = javascript_include_tag 'application', 'data-turbolinks-track': 'reload'
  %body
    %nav.navbar.navbar-default
      .container
        .navbar-header
          %button{type: "button", class: "navbar-toggle collapsed", data: { toggle: "collapse", target: "#admin-navbar-collapse" }, aria: { expanded: "false" }}
            %span.sr-only Toggle navigation
            %span.icon-bar
            %span.icon-bar
            %span.icon-bar
          %a.navbar-brand{href: root_url}= t("admin.site_name")
        .collapse.navbar-collapse#admin-navbar-collapse
          %ul.nav.navbar-nav
            = render "layouts/admin_menu"
          - if logged_in?
            %ul.nav.navbar-nav.navbar-right
              %li= link_to t("admin.auth.logout"), admin_logout_path
    .container
      - if flash[:success]
        .alert.alert-success.alert-dismissible
          %a{href: "#", class: "close", data: { dismiss: "alert" }, aria: { label: "close" }} &times;
          = flash[:success]
      - if flash[:error]
        .alert.alert-danger.alert-dismissible
          %a{href: "#", class: "close", data: { dismiss: "alert" }, aria: { label: "close" }} &times;
          = flash[:error]
      = yield
EOF
        end
      end

      def create_admin_layouts
        return false unless options[:admin]

        create_file 'app/views/layouts/admin.html.haml'
        append_to_file 'app/views/layouts/admin.html.haml' do
<<-EOF
%html
  %head
    %meta(content="text/html; charset=UTF-8" http-equiv="Content-Type")
    %title
      = content_for(:title)
    = csrf_meta_tags
    = stylesheet_link_tag    'admin', media: 'all', 'data-turbolinks-track': 'reload'
    = javascript_include_tag 'admin', 'data-turbolinks-track': 'reload'
  %body
    %nav.navbar.navbar-default
      .container
        .navbar-header
          %button{type: "button", class: "navbar-toggle collapsed", data: { toggle: "collapse", target: "#admin-navbar-collapse" }, aria: { expanded: "false" }}
            %span.sr-only Toggle navigation
            %span.icon-bar
            %span.icon-bar
            %span.icon-bar
          %a.navbar-brand{href: root_url}= t("admin.site_name")
        .collapse.navbar-collapse#admin-navbar-collapse
          %ul.nav.navbar-nav
            = render "layouts/admin_menu"
          - if logged_in?
            %ul.nav.navbar-nav.navbar-right
              %li= link_to t("admin.auth.logout"), admin_logout_path
    .container
      - if flash[:success]
        .alert.alert-success.alert-dismissible
          %a{href: "#", class: "close", data: { dismiss: "alert" }, aria: { label: "close" }} &times;
          = flash[:success]
      - if flash[:error]
        .alert.alert-danger.alert-dismissible
          %a{href: "#", class: "close", data: { dismiss: "alert" }, aria: { label: "close" }} &times;
          = flash[:error]
      = yield
EOF
        end
      end
    end
  end
end
