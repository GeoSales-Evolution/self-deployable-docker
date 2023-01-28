# frozen_string_literal: true

require_relative '../lib/ouroborus/container'
require_relative '../lib/ouroborus/args'

require 'rspec/autorun'

describe Ouroborus::Args do
  it 'should escape quotes, space, dolar, hash, bang and brackets' do
    args = Ouroborus::Args.new
    args << 'abc'
    args << 'lalala lelele'
    expect(args.to_s).to eq('abc lalala\\ lelele')
  end
end

describe Ouroborus::Container do
  def emptyContainer
    Ouroborus::Container.new name: 'lala', image: 'leli'
  end

  PREFIX = "docker run -d"
  SUFFIX = "--name lala leli:latest"

  def expectation(expected)
    Proc.new {
      |obtained|
      expect(obtained).to eq("#{PREFIX} #{expected} #{SUFFIX}")
    }
  end

  it 'should add an arg to a container' do
    container = emptyContainer
    container.port 27
    container.startCommand(&expectation("-p 27"))
  end
  it 'should add a port to a container with mapping' do
    container = emptyContainer
    container.port 80,8080
    container.startCommand(&expectation("-p 80:8080"))
  end

  it 'should set an envvar' do
    container = emptyContainer
    container.env "JAVA_HOME"
    container.startCommand(&expectation("--env JAVA_HOME"))
  end
  it 'should set some envvar' do
    container = emptyContainer
    container.env ["JAVA_HOME", "MARMOTA", "CAMINHANTES_BRANCOS"]
    container.startCommand(&expectation("--env JAVA_HOME --env MARMOTA --env CAMINHANTES_BRANCOS"))
  end
  it 'should set some envvar with values' do
    container = emptyContainer
    container.env ["JAVA_HOME", "MARMOTA", "CAMINHANTES_BRANCOS"], [nil, "tante", "wight"]
    container.startCommand(&expectation("--env JAVA_HOME --env MARMOTA=tante --env CAMINHANTES_BRANCOS=wight"))
  end
  it 'should set some envvar with values' do
    container = emptyContainer
    container.env({"JAVA_HOME" => nil, "MARMOTA" => "tante", "CAMINHANTES_BRANCOS" => "wight"})
    container.startCommand(&expectation("--env JAVA_HOME --env MARMOTA=tante --env CAMINHANTES_BRANCOS=wight"))
  end
end
