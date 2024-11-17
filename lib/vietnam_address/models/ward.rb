module VietnamAddress
	 class Ward
    attr_reader :id, :name, :code, :district_id

    def initialize(attributes = {})
      @id = attributes['id']
      @name = attributes['name']
      @code = attributes['code']
      @district_id = attributes['district_id']
    end

    def self.all
      @wards ||= begin
        file_path = File.join(VietnamAddress.configuration.data_path, 'wards.json')
        JSON.parse(File.read(file_path)).map { |attrs| new(attrs) }
      end
    end
  end
end
