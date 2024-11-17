module VietnamAddress
  class Ward
    attr_reader :id, :name, :code, :district_id

    class << self
      def find_by_id(id)
        all.find { |ward| ward.id == id }
      end

      def find_by_name(name)
        all.find { |ward| ward.name == name }
      end

      def find_by_district_id(district_id)
        all.select { |ward| ward.district_id == district_id }
      end

      private

      def all
        @wards ||= load_wards
      end

      def load_wards
        district = District.find_by_id(district_id)
        data = read_json_file("#{VietnamAddress.configuration.data_path}/#{district.province.location}/districts/#{district.id.to_s.rjust(3, '0')}_#{district.name.parameterize}/wards.json")
        data.map { |attrs| new(attrs) }
      rescue JSON::ParserError => e
        raise Error, "Invalid JSON in wards.json for district #{district_id}: #{e.message}"
      rescue Errno::ENOENT
        raise Error, "wards.json not found for district #{district_id} in #{VietnamAddress.configuration.data_path}/#{district.province.location}/districts/#{district.id.to_s.rjust(3, '0')}_#{district.name.parameterize}"
      end

      def read_json_file(filename)
        file_path = File.join(VietnamAddress.configuration.data_path, filename)
        JSON.parse(File.read(file_path))
      end
    end

    def initialize(attributes = {})
      validate_attributes!(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @code = attributes['code']
      @district_id = attributes['district_id']
    end

    def district
      @district ||= District.find_by_id(district_id)
    end

    def province
      @province ||= district&.province
    end

    def ==(other)
      other.class == self.class && other.id == id
    end

    alias eql? ==

    def hash
      [self.class, id].hash
    end

    def inspect
      "#<#{self.class} id=#{id} name=#{name} code=#{code} district_id=#{district_id}>"
    end

    alias to_s inspect

    private

    def validate_attributes!(attributes)
      %w[id name code district_id].each do |attr|
        raise ArgumentError, "Missing #{attr}" if attributes[attr].nil?
      end
    end
  end
end
