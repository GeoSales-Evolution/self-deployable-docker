# frozen_string_literal: true

require_relative '../lib/ouroborus/container'

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

  PREFIX = "docker run"
  SUFFIX = "--name lala leli:latest"
  it 'should add an arg to a container' do
    container = emptyContainer
    container.port 27
    expect(container.to_s).to eq("#{PREFIX} -p 27 #{SUFFIX}")
  end
  it 'should add a port to a container with mapping' do
    container = emptyContainer
    container.port 80,8080
    expect(container.to_s).to eq("#{PREFIX} -p 80:8080 #{SUFFIX}")
  end
end
