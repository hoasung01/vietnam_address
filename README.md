# Vietnam Address 🇻🇳

A Ruby gem providing comprehensive data and utilities for Vietnamese administrative divisions (Provinces, Districts, and Wards).

## Features
✨ Complete list of Vietnamese provinces and districts  
🚀 Easy-to-use API for accessing administrative data  
🛠️ Rails form helpers for address selection  
📦 Simple JSON data structure  
⚡ Lightweight and performant  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vietnam_address', github: 'hoasung01/vietnam_address'
```

Then execute:
```bash
$ bundle install
```

## Configuration (Optional)

By default, the gem will use its built-in data path: `Gem.loaded_specs['vietnam_address'].gem_dir + '/data'`

If you want to override the default data path, create an initializer file `config/initializers/vietnam_address.rb`:

```ruby
# config/initializers/vietnam_address.rb
# Optional: Only needed if you want to use custom data location
VietnamAddress.configure do |config|
  config.data_path = Rails.root.join('vendor/vietnam_address_data')
end
```

### Default Directory Structure
```
[GEM_ROOT]/data/
├── provinces.json
└── khanhhoa/
    ├── districts.json
    └── districts/
        ├── 001_camlam/
        │   └── wards.json
        ├── 002_camranh/
        │   └── wards.json
        └── ...
```

### Custom Directory Structure (if configured)
```
[RAILS_ROOT]/vendor/vietnam_address_data/
├── provinces.json
└── khanhhoa/
    ├── districts.json
    └── districts/
        ├── 001_camlam/
        │   └── wards.json
        ├── 002_camranh/
        │   └── wards.json
        └── ...
```

Note: The directory structure remains the same whether you use the default or custom path. Only configure a custom path if you need to:
- Override the default data with your own data files
- Store the data in a different location for your specific use case
- Maintain separate data files for different environments

## Basic Usage

Currently supports Khanh Hoa province only.

### Getting Province
```ruby
# Get Khanh Hoa province
province = VietnamAddress::Province.find_by_id('32')
# or
province = VietnamAddress::Province.find_by_name('Khánh Hòa')
# or
province = VietnamAddress::Province.find_by_slug('khanhhoa')

# Returns:
# #<VietnamAddress::Province id: "32", name: "Khánh Hòa", slug: "khanhhoa">
```

### Getting Districts
```ruby
# Get all districts of Khanh Hoa
districts = province.districts

# Returns:
# [
#   #<VietnamAddress::District 
#     id: "001", 
#     name: "Cam Lâm", 
#     district_slug: "camlam",
#     province_id: "32",
#     province_slug: "khanhhoa"
#   >,
#   ...
# ]
```

### Getting Wards
```ruby
# Get all wards of a specific district
district = province.districts.first
wards = district.wards

# Returns:
# [
#   #<VietnamAddress::Ward 
#     id: "001",
#     name: "Cam Phước Đông",
#     district_id: "001",
#     province_slug: "khanhhoa"
#   >,
#   ...
# ]
```

### Associations
```ruby
# District associations
district.province  # Returns Khanh Hoa province

# Ward associations
ward.district   # Returns associated district
ward.province   # Returns Khanh Hoa province
```

## Rails Integration

### In Controllers

```ruby
class LocationsController < ApplicationController
  def provinces
    @province = VietnamAddress::Province.find_by_slug('khanhhoa')
    @districts = @province.districts
  end

  def districts
    @province = VietnamAddress::Province.find_by_slug(params[:province_slug])
    @districts = @province.districts
    
    respond_to do |format|
      format.json { render json: @districts }
    end
  end

  def wards
    @province = VietnamAddress::Province.find_by_slug(params[:province_slug])
    @district = @province.districts.find { |d| d.district_slug == params[:district_slug] }
    @wards = @district.wards

    respond_to do |format|
      format.json { render json: @wards }
    end
  end
end
```

### Routes Configuration

```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :locations, only: [] do
    collection do
      get 'provinces'
      get 'districts'
      get 'wards'
    end
  end
end
```

### In Views

```erb
<%# app/views/locations/index.html.erb %>

<div class="location-selector">
  <div class="district-select">
    <h3>Districts in Khanh Hoa:</h3>
    <ul>
      <% @province.districts.each do |district| %>
        <li><%= district.name %> (<%= district.id %>)</li>
      <% end %>
    </ul>
  </div>

  <% if @district %>
    <div class="ward-select">
      <h3>Wards in <%= @district.name %>:</h3>
      <ul>
        <% @district.wards.each do |ward| %>
          <li><%= ward.name %> (<%= ward.id %>)</li>
        <% end %>
      </ul>
    </div>
  <% end %>
</div>
```

### Form Integration

```erb
<%# app/views/addresses/_form.html.erb %>

<%= form_with(model: @address) do |f| %>
  <div class="field">
    <%= f.label :district %>
    <%= f.select :district_id, 
                 @province.districts.map { |d| [d.name, d.id] },
                 { prompt: "Select District" },
                 data: { 
                   controller: "districts",
                   action: "change->districts#loadWards"
                 } 
    %>
  </div>

  <div class="field">
    <%= f.label :ward %>
    <%= f.select :ward_id, 
                 [], 
                 { prompt: "Select Ward" },
                 data: { districts_target: "wardSelect" } 
    %>
  </div>
<% end %>
```

### With Stimulus.js (Optional)

```javascript
// app/javascript/controllers/districts_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wardSelect"]

  loadWards(event) {
    const districtId = event.target.value
    const provinceSlug = 'khanhhoa'  // Currently only supporting Khanh Hoa

    if (!districtId) return

    fetch(`/locations/wards?province_slug=${provinceSlug}&district_id=${districtId}`)
      .then(response => response.json())
      .then(wards => {
        this.wardSelectTarget.innerHTML = '<option value="">Select Ward</option>'
        wards.forEach(ward => {
          const option = new Option(ward.name, ward.id)
          this.wardSelectTarget.add(option)
        })
      })
  }
}
```

### Model Integration (Optional)

```ruby
# app/models/address.rb

class Address < ApplicationRecord
  def district
    @district ||= begin
      province = VietnamAddress::Province.find_by_slug('khanhhoa')
      province.districts.find { |d| d.id == district_id }
    end
  end

  def ward
    @ward ||= district&.wards&.find { |w| w.id == ward_id }
  end
end
```

## Important Notes

1. Currently only supports Khanh Hoa province
2. All data is loaded from JSON files
3. Consider caching results if you need frequent access to the same data
4. The gem provides read-only access to location data
5. The data path configuration is optional - by default, it uses the gem's built-in data

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

## Support

⭐️ If you like this project, please give it a star on GitHub! ⭐️

Found a bug? [Create an issue](https://github.com/hoasung01/vietnam_address/issues)
