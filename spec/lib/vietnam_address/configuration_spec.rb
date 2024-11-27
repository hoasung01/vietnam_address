require 'spec_helper'

RSpec.describe VietnamAddress::Configuration do
  let(:default_path) { File.join(File.dirname(File.expand_path(__FILE__)), '../data') }

  describe '#initialize' do
    it 'sets default data path' do
      config = described_class.new
      expect(config.data_path).to include('/data')
    end
  end

  describe '#data_path=' do
    it 'allows setting custom path' do
      config = described_class.new
      custom_path = '/custom/path'
      config.data_path = custom_path
      expect(config.data_path).to eq(custom_path)
    end
  end

  describe '#reset_configuration!' do
    it 'resets to default path' do
      config = described_class.new
      config.data_path = '/custom/path'
      config.reset_configuration!
      expect(config.data_path).to include('/data')
    end
  end
end
