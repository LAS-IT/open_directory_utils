
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "open_directory_utils/version"

Gem::Specification.new do |spec|
  spec.name          = "open_directory_utils"
  spec.version       = OpenDirectoryUtils::Version::VERSION
  spec.authors       = ["Bill Tihen", "Lee Weisbecker"]
  spec.email         = ["btihen@gmail.com", "leeweisbecker@gmail.com"]

  spec.summary       = %q{A ruby wrapper to access MacOpenDirectory management commands remotely}
  spec.description   = %q{Create and update users and groups on a MacOpenDirectory Server}
  spec.homepage      = "https://github.com/LAS-IT/open_directory_utils"
  spec.license       = "MIT"

  # # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "net-ssh", "~> 4.2"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.7"
end
