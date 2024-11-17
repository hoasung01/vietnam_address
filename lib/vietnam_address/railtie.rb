require 'rails/railtie'

module VietnamAddress
  class Railtie < Rails::Railtie
    initializer "vietnam_address.configure_rails_initialization" do
      # Add initialization code here if needed
    end

    # Add view helpers if needed
    initializer "vietnam_address.view_helpers" do
      ActionView::Base.include VietnamAddress::ViewHelpers
    end
  end
end
