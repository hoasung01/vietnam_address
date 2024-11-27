require 'spec_helper'

RSpec.describe VietnamAddress::Province do
  let(:valid_attributes) do
    {
      'id' => '01',
      'name' => 'Ha Noi',
      'slug' => 'hanoi'
    }
  end

  let(:provinces_data) do
    [
      valid_attributes,
      {
        'id' => '02',
        'name' => 'Ho Chi Minh',
        'slug' => 'hochiminh'
      }
    ]
  end

  before do
    # Reset configuration and class variables
    VietnamAddress.configuration.reset_configuration!
    described_class.instance_variable_set(:@provinces, nil)
  end

  describe '.all' do
    context 'with valid JSON' do
      before do
        allow(File).to receive(:read)
          .with("#{VietnamAddress.configuration.data_path}/provinces.json")
          .and_return(provinces_data.to_json)
      end

      it 'loads and caches provinces' do
        provinces = described_class.all
        expect(provinces.length).to eq(2)
        expect(provinces.first).to be_a(described_class)
        expect(File).to have_received(:read).once

        # Verify caching
        described_class.all
        expect(File).to have_received(:read).once
      end
    end

    context 'when JSON is invalid' do
      before do
        allow(File).to receive(:read)
          .with("#{VietnamAddress.configuration.data_path}/provinces.json")
          .and_return('invalid json')
        allow(JSON).to receive(:parse).and_raise(JSON::ParserError.new("Invalid JSON"))
      end

      it 'raises error with message' do
        expect { described_class.all }.to raise_error(RuntimeError, /Invalid JSON in provinces.json: Invalid JSON/)
      end
    end

    context 'when file is missing' do
      before do
        allow(File).to receive(:read)
          .with("#{VietnamAddress.configuration.data_path}/provinces.json")
          .and_raise(Errno::ENOENT)
      end

      it 'raises error with path' do
        expect { described_class.all }
          .to raise_error(RuntimeError, /provinces.json not found in #{VietnamAddress.configuration.data_path}/)
      end
    end
  end

  describe '.find_by_id' do
    before do
      allow(File).to receive(:read)
        .with("#{VietnamAddress.configuration.data_path}/provinces.json")
        .and_return(provinces_data.to_json)
    end

    it 'returns province with matching id' do
      province = described_class.find_by_id('01')
      expect(province.name).to eq('Ha Noi')
    end

    it 'returns nil when no match' do
      expect(described_class.find_by_id('99')).to be_nil
    end
  end

  describe '.find_by_name' do
    before do
      allow(File).to receive(:read)
        .with("#{VietnamAddress.configuration.data_path}/provinces.json")
        .and_return(provinces_data.to_json)
    end

    it 'returns province with matching name' do
      province = described_class.find_by_name('Ha Noi')
      expect(province.id).to eq('01')
    end

    it 'returns nil when no match' do
      expect(described_class.find_by_name('Invalid')).to be_nil
    end
  end

  describe '.find_by_slug' do
    before do
      allow(File).to receive(:read)
        .with("#{VietnamAddress.configuration.data_path}/provinces.json")
        .and_return(provinces_data.to_json)
    end

    it 'returns province with matching slug' do
      province = described_class.find_by_slug('hanoi')
      expect(province.name).to eq('Ha Noi')
    end

    it 'returns nil when no match' do
      expect(described_class.find_by_slug('invalid')).to be_nil
    end
  end

  describe '#initialize' do
    subject(:province) { described_class.new(valid_attributes) }

    it 'sets attributes correctly' do
      expect(province.id).to eq('01')
      expect(province.name).to eq('Ha Noi')
      expect(province.slug).to eq('hanoi')
    end
  end

  describe '#districts' do
    subject(:province) { described_class.new(valid_attributes) }

    it 'loads districts for the province' do
      districts = double('districts')
      allow(VietnamAddress::District).to receive(:load_districts)
        .with(province.slug)
        .and_return(districts)

      expect(province.districts).to eq(districts)
      # Verify caching
      province.districts
      expect(VietnamAddress::District).to have_received(:load_districts).once
    end
  end
end
