# frozen_string_literal: true

require 'rake'
begin
  require_relative 'lib/ouroborus/version.rb'
   version = Ouroborus::VERSION
rescue LoadError
  version = '0.0.1'
end


Gem::Specification.new do |spec|
   spec.name = "ouroborus"
   spec.version = version
   spec.authors = [ "Jefferson Quesado" ]
   spec.email = [ "jeff.quesado@gmail.com" ]

   spec.summary = "Server capable of reraise itself using docker"
   spec.license = "MIT"
   spec.required_ruby_version = "~> 3.0"
   spec.bindir = "bin"

   spec.files = FileList[
     "lib/**/*.rb"
   ].to_a
   spec.executables << "ouroborus"
end

