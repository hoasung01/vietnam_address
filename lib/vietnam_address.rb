require 'json'
require "vietnam_address/version"
require "vietnam_address/configuration"
require "vietnam_address/models/province"
require "vietnam_address/models/district"
require "vietnam_address/models/ward"
require "vietnam_address/view_helpers"
require "vietnam_address/railtie" if defined?(Rails)

module VietnamAddress
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end
  end
end
