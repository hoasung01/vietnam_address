# Vietnam Address

A Ruby gem providing comprehensive data and utilities for Vietnamese administrative divisions (Provinces, Districts, and Wards).

## Features

- Complete list of Vietnamese provinces, districts, and wards
- Easy-to-use API for accessing administrative data
- Hierarchical data structure
- Rails form helpers for address selection
- JSON data format
- Lightweight and performant

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vietnam_address'
```
And then execute:
```bash
bundle install
```
Or install it yourself as:

```bash
gem install vietnam_address
```

Usage
Basic Usage
```ruby
# Get all provinces
provinces = VietnamAddress::Data::Structure.provinces

# Get specific province with districts
hanoi = VietnamAddress::Data::Structure.load_province('01')

# Get districts of a province
hanoi_districts = VietnamAddress::Data::Structure.districts('01')

# Get wards of a district
wards = VietnamAddress::Data::Structure.wards('01', '001')
```

In Rails Forms
```erb
<%= form_for @address do |f| %>
  <%= province_select f %>
  <%= district_select f, @address.province_id %>
  <%= ward_select f, @address.district_id %>
<% end %>
```

With JavaScript for Dynamic Updates
```javascript
$(document).on('change', '#address_province_id', function() {
  var province_id = $(this).val();
  $.get('/districts', { province_id: province_id }, function(data) {
    $('#address_district_id').html(data);
  });
});

$(document).on('change', '#address_district_id', function() {
  var district_id = $(this).val();
  $.get('/wards', { district_id: district_id }, function(data) {
    $('#address_ward_id').html(data);
  });
});
```

Configuration
```ruby
# config/initializers/vietnam_address.rb
VietnamAddress.configure do |config|
  config.data_path = Rails.root.join('data', 'vietnam_address')
end
```

Data Structure
```json{
  "provinces": {
    "01": {
      "info": {
        "id": "01",
        "name": "Hà Nội",
        "code": "HN"
      },
      "districts": {
        "001": {
          "id": "001",
          "name": "Ba Đình",
          "code": "BD",
          "wards": {
            "00001": {
              "id": "00001",
              "name": "Phúc Xá",
              "code": "PX"
            }
          }
        }
      }
    }
  }
}
```
Development
After checking out the repo, run bin/setup to install dependencies. You can also run bin/console for an interactive prompt that will allow you to experiment.
To install this gem onto your local machine, run bundle exec rake install.
Contributing

Fork it
Create your feature branch (git checkout -b feature/my-new-feature)
Commit your changes (git commit -am 'Add some feature')
Push to the branch (git push origin feature/my-new-feature)
Create a new Pull Request

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/vietnam_address.
License
The gem is available as open source under the terms of the MIT License.
Code of Conduct
Everyone interacting in the VietnamAddress project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the code of conduct.
