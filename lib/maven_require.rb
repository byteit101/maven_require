# frozen_string_literal: true
require 'jar_dependencies'
require 'jars/installer'
require 'jars/maven_factory'
require 'jars/gemspec_artifacts'
require 'tempfile'

def maven_require *args
	builder = MavenRequire::RequireMavenBuilder.new
	if args.empty?
		yield builder
	else
		builder.jar(*args)
	end
	MavenRequire::RuntimeInstaller.new(builder).execute
end

module MavenRequire
	class RequireMavenBuilder
		def initialize
			@items = []
			@options = {}
		end
		def [](k)
			@options[k]
		end
		def []=(k,v)
			@options[k] = v
		end
		def options
			@options
		end
		def jar(group, artifact=nil, ver='LATEST')
			if artifact.nil?
				@items << "jar #{group.gsub(":", ",")}#{group.split(":").length == 2 ? ', LATEST' : ""}"
			else
				@items << "jar #{group}, #{artifact}, #{ver}"
			end
		end
		def requirements
			@items
		end
	end

	class RuntimeInstaller
		def initialize(builder)
			@options = builder.options
			@list = builder
		end
		def resolve_dependencies_list(file)
			factory = Jars::MavenFactory.new(@options)
			#maven = factory.maven_new(File.expand_path('../gemspec_pom.rb', __FILE__))
			# Extract the path to the jar_dependencies' pom
			maven = factory.maven_new(File.expand_path('../gemspec_pom.rb', $LOADED_FEATURES.find{|x|x =~ /jars\/maven_factory\.rb$/}))

			maven.attach_jars(@list, false)

			maven['outputAbsoluteArtifactFilename'] = 'true'
			maven['includeTypes'] = 'jar'
			maven['outputScope'] = 'true'
			maven['useRepositoryLayout'] = 'true'
			maven['outputDirectory'] = Jars.home.to_s
			maven['outputFile'] = file.to_s

			maven.exec('dependency:copy-dependencies', 'dependency:list')
		end
		def execute
			Tempfile.open("deps.lst") do |deps_file|
				raise LoadError, "Maven Resolve failed (see stdout/stderr)" unless resolve_dependencies_list(deps_file.path)

				puts File.read deps_file.path if Jars.debug?

				jars = Jars::Installer.load_from_maven(deps_file.path)
				raise LoadError, "Maven Resolve returned no results" unless jars.length >= 1
				jars.each do |id|
					require(id.file)
				end
			end
		end
	end
end
