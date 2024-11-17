module VietnamAddress
  class Province
    attr_reader :id, :name, :code, :districts

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
      @districts = load_districts
    end

    private

    def load_districts
      return @districts if defined?(@districts)

      begin
        data = self.class.send(:read_json_file, 'districts.json')
        data.select { |d| d['province_id'] == id }
            .map { |d| District.new(d) }
      rescue JSON::ParserError => e
        raise Error, "Invalid JSON in districts.json: #{e.message}"
      rescue Errno::ENOENT
        raise Error, "districts.json not found in #{self.class.send(:data_path)}"
      end
    end

    def ==(other)
      other.class == self.class && other.id == id
    end
    alias eql? ==

    def hash
      [self.class, id].hash
    end

    def inspect
      "#<#{self.class} id=#{id} name=#{name} code=#{code} districts=#{districts.size}>"
    end
    alias to_s inspect
  end
end
