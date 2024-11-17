module VietnamAddress
  class District
    attr_reader :id, :name, :code, :province_id, :wards

    class << self
      def load_districts(location)
        data = read_json_file("#{location}/districts.json")
        data.map { |attrs| new(attrs) }
      rescue JSON::ParserError => e
        raise Error, "Invalid JSON in districts.json for #{location}: #{e.message}"
      rescue Errno::ENOENT
        raise Error, "districts.json not found in #{data_path}/#{location}"
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

      def all
        @districts ||= load_districts(VietnamAddress.configuration.data_path)
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

    private

    def load_wards
      data = read_json_file("#{province.location}/districts/#{id.to_s.rjust(3, '0')}_#{name.parameterize}/wards.json")
      data.map { |w| Ward.new(w) }
    rescue JSON::ParserError => e
      raise Error, "Invalid JSON in wards.json for district #{id}: #{e.message}"
    rescue Errno::ENOENT
      raise Error, "wards.json not found for district #{id} in #{data_path}/#{province.location}/districts/#{id.to_s.rjust(3, '0')}_#{name.parameterize}"
    end

    def read_json_file(filename)
      file_path = File.join(data_path, filename)
      JSON.parse(File.read(file_path))
    end

    def data_path
      VietnamAddress.configuration.data_path
    end

    def validate_attributes!(attributes)
      %w[id name code province_id].each do |attr|
        raise ArgumentError, "Missing #{attr}" if attributes[attr].nil?
      end
    end
  end
end
