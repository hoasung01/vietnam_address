module VietnamAddress
  class Configuration
    attr_accessor :data_path

    def initialize
      @data_path = File.join(File.dirname(__FILE__), '..', '..', 'data')
    end
  end
end
