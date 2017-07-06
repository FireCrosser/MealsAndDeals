# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
# Singularize table names
ActiveRecord::Base.pluralize_table_names = false
