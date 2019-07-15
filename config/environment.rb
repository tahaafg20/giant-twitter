require 'bundler/setup'

Bundler.require

require_relative '../app/controllers/application_controller'


ENV['SINATRA_ENV'] ||= "development"



require_all 'app'

