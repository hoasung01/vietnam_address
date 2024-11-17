module VietnamAddress
  class Province
    attr_reader :id, :name, :code, :slug

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

      def find_by_slug(slug)
        all.find { |province| province.slug == slug }
      end

      private

      def load_provinces
        data = read_json_file("#{VietnamAddress.configuration.data_path}/provinces.json")
        data.map { |attrs| new(attrs) }
      rescue JSON::ParserError => e
        raise "Invalid JSON in provinces.json: #{e.message}"
      rescue Errno::ENOENT
        raise "provinces.json not found in #{VietnamAddress.configuration.data_path}"
      end

      def read_json_file(filename)
        file_path = filename
        JSON.parse(File.read(file_path))
      end
    end

    def initialize(attributes = {})
      @id = attributes['id']
      @name = attributes['name']
      @code = attributes['code']
      @slug = attributes['slug']
    end

    def districts
      @districts ||= District.load_districts(slug)
    end
  end
end
