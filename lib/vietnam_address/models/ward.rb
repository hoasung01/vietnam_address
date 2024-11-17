module VietnamAddress
  class Ward
    attr_reader :id, :name, :code, :district_id, :province_slug

    def initialize(attributes = {})
      validate_attributes!(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @code = attributes['code']
      @district_id = attributes['district_id']
      @province_slug = attributes['province_slug']
    end

    def district
      @district ||= begin
        district_list = Province.find_by_slug(province_slug).districts
        district_list.find { |d| d.id == district_id }
      end
    end

    def province
      @province ||= Province.find_by_slug(province_slug)
    end

    private

    def validate_attributes!(attributes)
      %w[id name code district_id province_slug].each do |attr|
        raise ArgumentError, "Missing #{attr}" if attributes[attr].nil?
      end
    end
  end
end
