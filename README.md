# Vietnam Address 🇻🇳

A Ruby gem providing comprehensive data and utilities for Vietnamese administrative divisions (Provinces, Districts, and Wards).

[![Gem Version](https://badge.fury.io/rb/vietnam_address.svg)](https://badge.fury.io/rb/vietnam_address)

## Features

✨ Complete list of Vietnamese provinces and districts  
🚀 Easy-to-use API for accessing administrative data  
🛠️ Rails form helpers for address selection  
📦 Simple JSON data structure  
⚡ Lightweight and performant  

## Installation

### From GitHub

```ruby
# Gemfile
gem 'vietnam_address', github: 'hoasung01/vietnam_address'
```

Then execute:
```bash
$ bundle install
```

## Usage

### Basic Usage

```ruby
# Provinces
VietnamAddress::Province.all
# Returns:
# [
#   #<VietnamAddress::Province id="01" name="Hà Nội" code="HN">,
#   ...
# ]

# Find province
hanoi = VietnamAddress::Province.find_by_id('01')
hanoi = VietnamAddress::Province.find_by_name('Hà Nội')

# Get districts of a province
hanoi.districts 
# Returns:
# [
#   #<VietnamAddress::District id="001" name="Ba Đình" code="BD" province_id="01">,
#   ...
# ]

# Districts
districts = VietnamAddress::District.all
district = VietnamAddress::District.find_by_id('001')
district = VietnamAddress::District.find_by_name('Ba Đình')
district.province # Returns province object

# Find districts by province
hanoi_districts = VietnamAddress::District.find_by_province_id('01')
```

### Data Structure

#### provinces.json
```json
[
  {
    "id": "01",
    "name": "Hà Nội",
    "code": "HN"
  }
]
```

#### districts.json
```json
[
  {
    "id": "001",
    "name": "Ba Đình",
    "code": "BD",
    "province_id": "01"
  }
]
```

### Rails Integration

#### Form Helpers

```erb
<%= form_for @address do |f| %>
  <div class="form-group">
    <%= province_select f %>
  </div>
  
  <div class="form-group">
    <%= district_select f, @address.province_id %>
  </div>
<% end %>
```

#### Dynamic Updates with JavaScript

```javascript
// Update districts when province changes
$(document).on('change', '#address_province_id', function() {
  const province_id = $(this).val();
  $.get('/districts', { province_id }, function(data) {
    $('#address_district_id').html(data);
  });
});
```

### Configuration

```ruby
# config/initializers/vietnam_address.rb
VietnamAddress.configure do |config|
  # Optional: override default data path
  config.data_path = Rails.root.join('data', 'vietnam_address')
end
```

## Development

1. Clone the repo:
```bash
$ git clone https://github.com/hoasung01/vietnam_address.git
$ cd vietnam_address
```

2. Install dependencies:
```bash
$ bundle install
```

3. Start a console:
```bash
$ bin/console
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

👤 **Hai Nguyen**

* GitHub: [@hoasung01](https://github.com/hoasung01)

## Support

⭐️ If you like this project, please give it a star on GitHub! ⭐️

Found a bug? [Create an issue](https://github.com/hoasung01/vietnam_address/issues)
