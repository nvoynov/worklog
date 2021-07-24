# frozen_string_literal: true

require_relative "lib/worklog/version"

Gem::Specification.new do |spec|
  spec.name          = "worklog"
  spec.version       = Worklog::VERSION
  spec.authors       = ["Nikolay Voynov"]
  spec.email         = ["nvoynov@gmail.com"]

  spec.summary       = "Time logging DSL and CLI for extended reporting"
  spec.description   = %q(The Worklog gem provides a simple domain-specific language (DSL) for tracking work time and a command-line interface (CLI) for processing the time spent. It'll answer some basic questions like "how much time I've spent on this project this month?" or "how much I've earned the previous week?")
  spec.homepage      = "https://github.com/nvoynov/worklog"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/nvoynov/worklog"
  spec.metadata["changelog_uri"] = "https://github.com/nvoynov/worklog/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "thor", "~> 1.0.1"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
