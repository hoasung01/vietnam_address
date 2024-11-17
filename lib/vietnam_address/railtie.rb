require 'rails/railtie'
require 'vietnam_address/view_helpers'

module VietnamAddress
  class Railtie < Rails::Railtie
    initializer "vietnam_address.configure_rails_initialization" do
    end

    initializer "vietnam_address.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include VietnamAddress::ViewHelpers
      end
    end
  end
end
