NewsKeeper::Application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.action_mailer.default_url_options = { host: 'copevents.herokuapp.com' }

  ENV['TWILIO_SID'] = 'ACd9266d2be667a7314d92bee7c35830b9'
  ENV['TWILIO_SECRET'] = 'bfc702fd20e3b164ca4041ad300b3fe6'
  ENV['SECRET_TOKEN'] = '02048945f67ded6fda8747ea6405c1c069518c64e0412b8d9e1cdf0434c1aa11be7d3dec3e709deb4b7b8cdbe72319c9f0d3ad0761317c2a6f9062115bed54c5'
  ENV['RE_CAPTCHA_PUBLIC'] = '6LdvowYTAAAAACvEEQOHbN_6kLOh8pR5HXcf6hn1'
  ENV['RE_CAPTCHA_PRIVATE'] = '6LdvowYTAAAAACFJvKKEUyrU-H_2ZwCIs650JG_p'

  ENV['DB_HOST'] = 'localhost'
  ENV['DB_USERNAME'] = 'postgres'
  ENV['DB_PASSWORD'] = 'student'
  ENV['DB_DATABASE'] = 'diplom'
  ENV['DB_PORT'] = '5432'
end
