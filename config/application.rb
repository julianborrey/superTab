require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module TabSite
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
   

    #Need this to stop the wrapping of feilds with divs when the field has an error.
    #this will edit the style of the input fields by adding a class
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      attribute_offset = (html_tag =~ /class=['"]/); #user regex to get index of "class=..."
      html_tag.insert(attribute_offset + 7, "field-with-errors ");
      #"#{html_tag}".html_safe
      html_tag.html_safe
    }
  
    config.exceptions_app = self.routes;
   end
  
end
