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
