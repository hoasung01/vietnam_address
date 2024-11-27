module VietnamAddress
  class Configuration
    attr_accessor :data_path

    def initialize
      @data_path = default_data_path
    end

    def reset_configuration!
      @data_path = default_data_path
    end

    private

    def default_data_path
      File.join(File.dirname(__FILE__), '../data')
    end
  end
end
