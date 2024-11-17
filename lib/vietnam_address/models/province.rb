module VietnamAddress
  class Province
    attr_reader :id, :name, :code, :districts

    def initialize(attributes = {})
      @id = attributes['id']
      @name = attributes['name']
      @code = attributes['code']
      @districts = load_districts
    end

    def self.all
      @provinces ||= begin
        file_path = File.join(VietnamAddress.configuration.data_path, 'provinces.json')
        JSON.parse(File.read(file_path)).map { |attrs| new(attrs) }
      end
    end

    def self.find_by_id(id)
      all.find { |province| province.id == id }
    end

    def self.find_by_name(name)
      all.find { |province| province.name == name }
    end

    private

    def load_districts
      file_path = File.join(VietnamAddress.configuration.data_path, 'districts.json')
      districts_data = JSON.parse(File.read(file_path))
      districts_data.select { |d| d['province_id'] == id }.map { |d| District.new(d) }
    end
  end
end
