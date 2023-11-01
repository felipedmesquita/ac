# frozen_string_literal: true

require_relative "lib/ac/version"

Gem::Specification.new do |spec|
  spec.name = "ac"
  spec.version = Ac::VERSION
  spec.authors = ["felipedmesquita"]
  spec.email = ["16197684+felipedmesquita@users.noreply.github.com"]

  spec.summary = "Simple Api Client for Typhoeus"
  spec.homepage = "https://github.com/felipedmesquita/ac"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/felipedmesquita/ac"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ mini_mock/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "typhoeus"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
