# frozen_string_literal: true

require_relative "lib/maven_require/version"

Gem::Specification.new do |spec|
  spec.name          = "maven_require"
  spec.version       = MavenRequire::VERSION
  spec.authors       = ["Patrick Plenefisch"]
  spec.email         = ["simonpatp@gmail.com"]

  spec.summary       = "Interactively resolve Maven coordinates as a require line"
  spec.description   = "A gem to add maven_require, a method to install and load maven coordinates into the current session in JRuby"
  spec.homepage      = "https://github.com/byteit101/maven_require"
  spec.required_ruby_version = ">= 2.4.0"
  spec.platform = "java"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  #spec.metadata["changelog_uri"] = ""

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  #spec.bindir        = "exe"
  spec.executables   = [] #spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # jar depdendencies is builtin to jruby
  spec.add_dependency "jar-dependencies", "~> 0.4"
end
