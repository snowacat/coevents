require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(:default, Rails.env)

module NewsKeeper
  class Application < Rails::Application
     config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
     config.i18n.default_locale = :en

    # Settings for reCaptcha
    config.gem 'rack-recaptcha', lib: 'rack/recaptcha'
    config.middleware.use Rack::Recaptcha, public_key: ENV['RE_CAPTCHA_PUBLIC'], private_key: ENV['RE_CAPTCHA_PRIVATE']
  end
end
