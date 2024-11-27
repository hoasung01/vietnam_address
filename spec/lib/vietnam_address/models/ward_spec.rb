require 'spec_helper'

RSpec.describe VietnamAddress::Ward do
  let(:valid_attributes) do
    {
      'id' => '001',
      'name' => 'Phu Xuyen',
      'district_id' => '001',
      'province_slug' => 'hanoi'
    }
  end

  describe '#initialize' do
    context 'with valid attributes' do
      subject(:ward) { described_class.new(valid_attributes) }

      it 'sets attributes correctly' do
        expect(ward.id).to eq('001')
        expect(ward.name).to eq('Phu Xuyen')
        expect(ward.district_id).to eq('001')
        expect(ward.province_slug).to eq('hanoi')
      end
    end

    context 'with missing attributes' do
      %w[id name district_id province_slug].each do |attr|
        it "raises error when #{attr} is missing" do
          invalid_attrs = valid_attributes.reject { |k, _| k == attr }
          expect { described_class.new(invalid_attrs) }
            .to raise_error(ArgumentError, "Missing #{attr}")
        end
      end
    end
  end

  describe '#district' do
    subject(:ward) { described_class.new(valid_attributes) }

    it 'finds district through province' do
      district = instance_double(VietnamAddress::District, id: '001')
      province = instance_double(VietnamAddress::Province)
      districts = [district]

      allow(VietnamAddress::Province).to receive(:find_by_slug)
        .with(ward.province_slug)
        .and_return(province)
      allow(province).to receive(:districts).and_return(districts)

      expect(ward.district).to eq(district)

      # Test caching
      ward.district
      expect(province).to have_received(:districts).once
    end
  end

  describe '#province' do
    subject(:ward) { described_class.new(valid_attributes) }

    it 'finds province by slug' do
      province = instance_double(VietnamAddress::Province)
      allow(VietnamAddress::Province).to receive(:find_by_slug)
        .with(ward.province_slug)
        .and_return(province)

      expect(ward.province).to eq(province)

      # Test caching
      ward.province
      expect(VietnamAddress::Province).to have_received(:find_by_slug).once
    end
  end
end
