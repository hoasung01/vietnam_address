module VietnamAddress
  class District
    attr_reader :id, :name, :district_slug, :province_id, :province_slug, :wards

    class << self
      def load_districts(province_slug)
        data = read_json_file("#{VietnamAddress.configuration.data_path}/#{province_slug}/districts.json")
        data.map { |attrs| new(attrs.merge('province_slug' => province_slug)) }
      rescue JSON::ParserError => e
        raise "Invalid JSON in districts.json for province slug #{province_slug}: #{e.message}"
      rescue Errno::ENOENT
        raise "districts.json not found in #{VietnamAddress.configuration.data_path}/#{province_slug}"
      end

      def read_json_file(filename)
        file_path = filename
        JSON.parse(File.read(file_path))
      end
    end

    def initialize(attributes = {})
      @id = attributes['id']
      @name = attributes['name']
      @district_slug = attributes['district_slug']
      @province_id = attributes['province_id']
      @province_slug = attributes['province_slug']
      validate_attributes!
      @wards = load_wards
    end

    def province
      @province ||= Province.find_by_slug(province_slug)
    end

    private

    def load_wards
      data = self.class.read_json_file("#{VietnamAddress.configuration.data_path}/#{province_slug}/districts/#{id.to_s.rjust(3, '0')}_#{district_slug}/wards.json")
      data.map { |w| Ward.new(w.merge('province_slug' => province_slug)) }
    rescue JSON::ParserError => e
      raise "Invalid JSON in wards.json for district #{id}: #{e.message}"
    rescue Errno::ENOENT
      raise "wards.json not found for district #{id} in #{VietnamAddress.configuration.data_path}/#{province_slug}/districts/#{id.to_s.rjust(3, '0')}_#{district_slug}"
    end

    def validate_attributes!
      %w[id name district_slug province_id province_slug].each do |attr|
        raise ArgumentError, "Missing #{attr}" if instance_variable_get("@#{attr}").nil?
      end
    end
  end
end
