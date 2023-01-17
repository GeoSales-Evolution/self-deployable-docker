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
  it 'should add an arg to a container' do
    container = Ouroborus::Container.new name: 'lala', image: 'lala'
    container.port 27
    expect(container.args.to_s).to eq("-p 27")
  end
  it 'should add an arg to a container' do
    container = Ouroborus::Container.new name: 'lala', image: 'lala'
    container.port 80,8080
    expect(container.args.to_s).to eq("-p 80:8080")
  end
end
