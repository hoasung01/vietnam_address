require 'spec_helper'

RSpec.describe VietnamAddress do
  it 'has a version number' do
    expect(VietnamAddress::VERSION).not_to be nil
    expect(VietnamAddress::VERSION).to eq('0.1.2')
  end
end
