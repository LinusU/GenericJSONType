Pod::Spec.new do |s|
  s.name         = "GenericJSONType"
  s.version      = %x(git describe --tags --abbrev=0).chomp
  s.summary      = "A simple container for any JSON-data, that conforms to the `Codable` protocol"
  s.description  = "This package provides a simple container for any JSON-data, that conforms to the `Codable` protocol"
  s.homepage     = "https://github.com/LinusU/GenericJSONType"
  s.license      = "MIT"
  s.author       = { "Linus Unnebäck" => "linus@folkdatorn.se" }

  s.swift_version = "4.2"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"

  s.source       = { :git => "https://github.com/LinusU/GenericJSONType.git", :tag => "#{s.version}" }
  s.source_files = "Sources"
end
