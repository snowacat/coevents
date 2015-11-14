# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
NewsKeeper::Application.initialize!
# Time format
Time::DATE_FORMATS[:default] = "%Y-%m-%d %H:%M"