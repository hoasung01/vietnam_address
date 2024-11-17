module VietnamAddress
  module ViewHelpers
    def province_select(form, options = {})
      form.select :province_id,
                 VietnamAddress::Province.all.map { |p| [p.name, p.id] },
                 options
    end

    def district_select(form, province_id = nil, options = {})
      districts = if province_id
                   VietnamAddress::Province.find_by_id(province_id)&.districts || []
                 else
                   []
                 end

      form.select :district_id,
                 districts.map { |d| [d.name, d.id] },
                 options
    end

    def ward_select(form, district_id = nil, options = {})
      wards = if district_id
                VietnamAddress::District.find_by_id(district_id)&.wards || []
              else
                []
              end

      form.select :ward_id,
                 wards.map { |w| [w.name, w.id] },
                 options
    end
  end
end
