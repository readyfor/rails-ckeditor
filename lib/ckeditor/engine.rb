require 'rails'
require 'ckeditor'

module Ckeditor
  class Engine < ::Rails::Engine
    initializer "ckeditor_engine.add_middleware" do |app|
      app.middleware.insert_before(
        ActionDispatch::Cookies,
        "Ckeditor::Middleware",
        app.config.send(:session_options)[:key])
    end

    config.after_initialize do
      ActionView::Base.send :include, Ckeditor::ViewHelper
      ActionView::Helpers::FormBuilder.send :include, Ckeditor::FormBuilder

      if ActionView::Helpers::AssetTagHelper.respond_to?(:register_javascript_expansion)
        ActionView::Helpers::AssetTagHelper.register_javascript_expansion :ckeditor => ["ckeditor/ckeditor"]
      end

      # NOTE: 2015/7/7
      # このバージョンの CKEditor が想定する Formtastic はバージョンが古いため、ActiveAdmin が使う Formtastic と
      # コンフリクトしてしまう。(現在の Formatastic には以下の SemanticFormBuilder はない)
      # CKEditor の Formatastic 連携は使用していないとおもわれるので、以下をコメントアウトしておく。
      #
      # if Object.const_defined?("Formtastic")
      #   ::Formtastic::SemanticFormBuilder.send :include, Ckeditor::Hooks::FormtasticBuilder
      # end

      if Object.const_defined?("SimpleForm")
        ::SimpleForm::FormBuilder.send :include, Ckeditor::Hooks::SimpleFormBuilder
      end
    end
  end
end
