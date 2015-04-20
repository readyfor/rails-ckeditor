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

      if Object.const_defined?("Formtastic")
        ::Formtastic::SemanticFormBuilder.send :include, Ckeditor::Hooks::FormtasticBuilder
      end
      
      if Object.const_defined?("SimpleForm")
        ::SimpleForm::FormBuilder.send :include, Ckeditor::Hooks::SimpleFormBuilder
      end
    end
  end
end
