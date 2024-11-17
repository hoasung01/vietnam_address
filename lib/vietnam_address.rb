# frozen_string_literal: true

require_relative "vietnam_address/version"
require 'vietnam_address/railtie' if defined?(Rails)
require 'vietnam_address/configuration'
require 'vietnam_address/models/province'
require 'vietnam_address/models/district'
require 'vietnam_address/models/ward'

module VietnamAddress
  class Error < StandardError; end
  # Your code goes here...

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
