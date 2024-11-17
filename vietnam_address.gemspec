require_relative "lib/vietnam_address/version"

Gem::Specification.new do |spec|
  spec.name        = "vietnam_address"
  spec.version     = VietnamAddress::VERSION
  spec.authors     = ["hainguyen"]
  spec.email       = ["nguyenngochai.shipagent@gmail.com"]

  spec.summary     = "Vietnamese address helper for Rails"
  spec.description = "A comprehensive Ruby gem providing Vietnamese administrative divisions data (Provinces, Districts, and Wards) with Rails integration."
  spec.homepage    = "https://github.com/hoasung01/vietnam_address"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.0.0"
  spec.required_rubygems_version = ">= 2.0.0"

  # Specify which files should be added to the gem
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir[
      "lib/**/*",
      "data/**/*",
      "README.md",
      "LICENSE.txt",
      "CHANGELOG.md"
    ]
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "rails", ">= 6.0.0"
  spec.add_dependency "json", "~> 2.0"

  # Development dependencies
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "pry", "~> 0.14"

  # Metadata
  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "documentation_uri" => "#{spec.homepage}/blob/main/README.md",
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "rubygems_mfa_required" => "true",
    "github_repo" => "#{spec.homepage.sub('https://github.com/', '')}",
  }

  # Extra details
  spec.post_install_message = <<~MESSAGE
    Thanks for installing vietnam_address!
    Please see #{spec.homepage} for usage instructions.

    If you find any issues, please report them at:
    #{spec.homepage}/issues
  MESSAGE
end
