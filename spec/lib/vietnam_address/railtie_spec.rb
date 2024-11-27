require 'spec_helper'
require 'rails'
require 'active_support'
require 'vietnam_address/railtie'
require 'vietnam_address/view_helpers'

RSpec.describe VietnamAddress::Railtie do
  describe 'View Helpers Integration' do
    it 'configures view helpers inclusion on action_view load' do
      railtie = described_class.instance
      initializer = railtie.initializers.find { |i| i.name == "vietnam_address.view_helpers" }

      expect(ActiveSupport).to receive(:on_load).with(:action_view)

      initializer.run
    end
  end
end
