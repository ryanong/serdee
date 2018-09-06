
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "serdee/version"

Gem::Specification.new do |spec|
  spec.name          = "serdee"
  spec.version       = Serdee::VERSION
  spec.authors       = ["Ryan Ong"]
  spec.email         = ["ryanong@gmail.com"]

  spec.summary       = %q{Serdee is a serialization/deserialization library for mostly json}
  spec.description   = %q{Serdee is a highly customizable serialization and deserialization library that is strict by default.}
  spec.homepage      = "https://github.com/ryanong/serdee"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
