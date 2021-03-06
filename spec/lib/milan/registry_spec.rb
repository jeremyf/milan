require 'spec_helper'
require 'milan/registry'

RSpec.describe Milan::Registry do
  context 'resolvers' do
    context ':to_method_name' do
      [
        ["dc.title", "dc_title"],
        ["dc::title", "dc_title"],
        ["_DC::title_", "dc_title"]
      ].each_with_index do |(from_value, to_value), index|
        it "convertes #{from_value.inspect} to #{to_value.inspect} (Scenario ##{index})" do
          expect(described_class.resolve(:to_method_name, from_value)).to eq(to_value)
        end
      end
    end
  end

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
