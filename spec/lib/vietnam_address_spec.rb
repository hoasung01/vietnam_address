require 'spec_helper'

RSpec.describe VietnamAddress do
  describe '.configuration' do
    it 'returns configuration instance' do
      expect(described_class.configuration).to be_a(VietnamAddress::Configuration)
    end

    it 'caches configuration instance' do
      config = described_class.configuration
      expect(described_class.configuration).to be(config)
    end
  end

  describe '.configure' do
    it 'yields configuration instance' do
      expect { |b| described_class.configure(&b) }
        .to yield_with_args(VietnamAddress::Configuration)
    end

    it 'allows setting configuration values' do
      custom_path = '/custom/path'
      described_class.configure do |config|
        config.data_path = custom_path
      end
      expect(described_class.configuration.data_path).to eq(custom_path)
    end
  end
end
