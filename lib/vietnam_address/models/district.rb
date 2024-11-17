module VietnamAddress
  class District
    attr_reader :id, :name, :code, :province_id, :wards

    class << self
      def all
        @districts ||= load_districts
      end

      def find_by_id(id)
        all.find { |district| district.id == id }
      end

      def find_by_name(name)
        all.find { |district| district.name == name }
      end

      def find_by_province_id(province_id)
        all.select { |district| district.province_id == province_id }
      end

      private

      def load_districts
        data = read_json_file('districts.json')
        data.map { |attrs| new(attrs) }
      rescue JSON::ParserError => e
        raise Error, "Invalid JSON in districts.json: #{e.message}"
      rescue Errno::ENOENT
        raise Error, "districts.json not found in #{data_path}"
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
      validate_attributes!(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @code = attributes['code']
      @province_id = attributes['province_id']
      @wards = load_wards
    end

    def province
      @province ||= Province.find_by_id(province_id)
    end

    def ==(other)
      other.class == self.class && other.id == id
    end
    alias eql? ==

    def hash
      [self.class, id].hash
    end

    def inspect
      "#<#{self.class} id=#{id} name=#{name} code=#{code} province_id=#{province_id} wards=#{wards.size}>"
    end
    alias to_s inspect

    private

    def load_wards
      return @wards if defined?(@wards)

      begin
        data = self.class.send(:read_json_file, 'wards.json')
        data.select { |w| w['district_id'] == id }
            .map { |w| Ward.new(w) }
      rescue JSON::ParserError => e
        raise Error, "Invalid JSON in wards.json: #{e.message}"
      rescue Errno::ENOENT
        raise Error, "wards.json not found in #{self.class.send(:data_path)}"
      end
    end

    def validate_attributes!(attributes)
      %w[id name code province_id].each do |attr|
        raise ArgumentError, "Missing #{attr}" if attributes[attr].nil?
      end
    end
  end
end
