# lib/vietnam_address/models/province.rb
module VietnamAddress
  class Province
    attr_reader :id, :name, :code, :location

    class << self
      def all
        @provinces ||= load_provinces
      end

      def find_by_id(id)
        all.find { |province| province.id == id }
      end

      def find_by_name(name)
        all.find { |province| province.name == name }
      end

      private

      def load_provinces
        data = read_json_file('provinces.json')
        data.map { |attrs| new(attrs) }
      rescue JSON::ParserError => e
        raise Error, "Invalid JSON in provinces.json: #{e.message}"
      rescue Errno::ENOENT
        raise Error, "provinces.json not found in #{data_path}"
      end

      def read_json_file(filename)
        file_path = File.join(data_path, filename)
        JSON.parse(File.read(file_path))
      end

      def data_path
        VietnamAddress.configuration.data_path
      end
    end

    def initialize(attributes = {})
      @id = attributes['id']
      @name = attributes['name']
      @code = attributes['code']
      @location = attributes['location'] || attributes['name'].parameterize
    end

    def districts
      @districts ||= District.load_districts(location)
    end
  end
end
