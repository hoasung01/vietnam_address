module VietnamAddress
  class Configuration
    attr_accessor :data_path

    def initialize
      @data_path = Gem.loaded_specs['vietnam_address'].gem_dir + '/data'
    end
  end
end
