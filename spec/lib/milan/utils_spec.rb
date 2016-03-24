require 'spec_helper'
require 'milan/utils'

RSpec.describe Milan::Utils do
  context '.stringify_keys' do
    it 'only converts the top-level keys' do
      expect(described_class.stringify_keys(name: { first: 'Jeremy' })).to eq("name" => { first: 'Jeremy' })
    end
  end
  context '.deep_stringify_keys' do
    it 'converts all of keys' do
      expect(described_class.deep_stringify_keys(name: { first: 'Jeremy' })).to eq("name" => { "first" => 'Jeremy' })
    end
  end
end
