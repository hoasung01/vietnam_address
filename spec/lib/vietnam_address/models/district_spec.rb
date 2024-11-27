require 'spec_helper'

RSpec.describe VietnamAddress::District do
  let(:valid_attributes) do
    {
      'id' => '001',
      'name' => 'Ba Dinh',
      'district_slug' => 'badinh',
      'province_id' => '01',
      'province_slug' => 'hanoi'
    }
  end

  let(:districts_data) { [valid_attributes] }
  let(:wards_data) { [{ 'id' => '001', 'name' => 'Phu Xuyen', 'ward_slug' => 'phuxuyen', 'district_id' => '001' }] }

  before do
    VietnamAddress.configuration.reset_configuration!
    # Stub all file reads by default
    allow(File).to receive(:read).and_return(wards_data.to_json)
  end

  describe '.load_districts' do
    let(:province_slug) { 'hanoi' }
    let(:districts_path) { "#{VietnamAddress.configuration.data_path}/#{province_slug}/districts.json" }

    context 'with valid JSON' do
      before do
        allow(File).to receive(:read)
          .with(districts_path)
          .and_return(districts_data.to_json)
      end

      it 'loads districts with province_slug' do
        districts = described_class.load_districts(province_slug)
        expect(districts.length).to eq(1)
        expect(districts.first).to be_a(described_class)
        expect(districts.first.province_slug).to eq(province_slug)
      end
    end

    context 'when JSON is invalid' do
      before do
        allow(File).to receive(:read)
          .with(districts_path)
          .and_return('invalid')
        allow(JSON).to receive(:parse).and_raise(JSON::ParserError.new("Invalid JSON"))
      end

      it 'raises error with message' do
        expect { described_class.load_districts(province_slug) }
          .to raise_error(/Invalid JSON in districts.json for province slug #{province_slug}: Invalid JSON/)
      end
    end

    context 'when file is missing' do
      before do
        allow(File).to receive(:read)
          .with(districts_path)
          .and_raise(Errno::ENOENT)
      end

      it 'raises error with path' do
        expect { described_class.load_districts(province_slug) }
          .to raise_error(/districts.json not found in #{VietnamAddress.configuration.data_path}\/#{province_slug}/)
      end
    end
  end

  describe '#initialize' do
    context 'with valid attributes' do
      subject(:district) { described_class.new(valid_attributes) }

      it 'sets attributes correctly' do
        expect(district.id).to eq('001')
        expect(district.name).to eq('Ba Dinh')
        expect(district.district_slug).to eq('badinh')
        expect(district.province_id).to eq('01')
        expect(district.province_slug).to eq('hanoi')
      end
    end

    context 'with missing attributes' do
      %w[id name district_slug province_id province_slug].each do |attr|
        it "raises error when #{attr} is missing" do
          invalid_attrs = valid_attributes.reject { |k, _| k == attr }
          expect { described_class.new(invalid_attrs) }
            .to raise_error(ArgumentError, "Missing #{attr}")
        end
      end
    end
  end

  describe '#province' do
    subject(:district) { described_class.new(valid_attributes) }

    it 'finds province by slug' do
      province = instance_double(VietnamAddress::Province)
      allow(VietnamAddress::Province).to receive(:find_by_slug)
        .with(district.province_slug)
        .and_return(province)

      expect(district.province).to eq(province)
      district.province
      expect(VietnamAddress::Province).to have_received(:find_by_slug).once
    end
  end

  describe '#wards' do
    subject(:district) { described_class.new(valid_attributes) }
    
    let(:wards_path) do 
      "#{VietnamAddress.configuration.data_path}/#{valid_attributes['province_slug']}/districts/#{valid_attributes['id'].rjust(3, '0')}_#{valid_attributes['district_slug']}/wards.json"
    end

    context 'with valid JSON' do
      before do
        allow(File).to receive(:read).with(wards_path).and_return(wards_data.to_json)
      end

      it 'loads wards with province_slug' do
        expect(district.wards.length).to eq(1)
        expect(district.wards.first).to be_a(VietnamAddress::Ward)
        expect(district.wards.first.province_slug).to eq(valid_attributes['province_slug'])
      end
    end

    context 'when JSON is invalid' do
      before do
        allow(File).to receive(:read).with(wards_path).and_return('invalid')
        allow(JSON).to receive(:parse).and_raise(JSON::ParserError.new("Invalid JSON"))
      end

      it 'raises error' do
        expect { district.wards }
          .to raise_error(/Invalid JSON in wards.json for district #{valid_attributes['id']}: Invalid JSON/)
      end
    end

    context 'when file is missing' do
      before do
        allow(File).to receive(:read).with(wards_path).and_raise(Errno::ENOENT)
      end

      it 'raises error with path' do
        expect { district.wards }
          .to raise_error(/wards.json not found for district #{valid_attributes['id']} in #{VietnamAddress.configuration.data_path}/)
      end
    end
  end
end
