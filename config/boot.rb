ENV["RACK_ENV"]    ||= "development"
ENV["CONFIG_FILE"] ||= File.expand_path("../application.yml.sample", __FILE__)

require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

OmniAuth.config.on_failure = Proc.new { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }

require_relative "settings"
