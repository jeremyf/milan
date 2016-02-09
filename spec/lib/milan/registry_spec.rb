require 'spec_helper'
require 'milan/registry'

RSpec.describe Milan::Registry do
  it 'exposes .resolve as a convenience method' do
    expect(described_class.resolve(:predicate_builder, predicate: 'dc_title')).to be_a(Milan::Predicate)
  end

  context '.resolver_for' do
    it 'will return a callable object if there is a name in the registry' do
      expect(described_class.resolver_for(:predicate_builder)).to respond_to(:call)
    end

    it 'will raise an exception if the name is NOT in the registry' do
      expect { described_class.resolver_for(:bogus) }.to raise_error(Dry::Container::Error)
    end
  end
end
