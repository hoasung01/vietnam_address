module VietnamAddress
  class District
    attr_reader :id, :name, :code, :province_id, :wards

    def initialize(attributes = {})
      @id = attributes['id']
      @name = attributes['name']
      @code = attributes['code']
      @province_id = attributes['province_id']
      @wards = load_wards
    end

    def self.all
      @districts ||= begin
        file_path = File.join(VietnamAddress.configuration.data_path, 'districts.json')
        JSON.parse(File.read(file_path)).map { |attrs| new(attrs) }
      end
    end

    private

    def load_wards
      file_path = File.join(VietnamAddress.configuration.data_path, 'wards.json')
      wards_data = JSON.parse(File.read(file_path))
      wards_data.select { |w| w['district_id'] == id }.map { |w| Ward.new(w) }
    end
  end
end
