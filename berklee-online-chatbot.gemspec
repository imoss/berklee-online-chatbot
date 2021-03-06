Gem::Specification.new do |spec|
  spec.name          = "berklee-online-chatbot"
  spec.version       = "0.0.1"
  spec.authors       = ["Ian Moss"]
  spec.email         = ["imoss@berklee.edu"]
  spec.description   = ""
  spec.summary       = ""
  spec.homepage      = ""
  spec.license       = ""
  spec.metadata      = { "lita_plugin_type" => "handler" }


  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", "~> 2.6"
  spec.add_runtime_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.14"
  spec.add_development_dependency "pry"
end
