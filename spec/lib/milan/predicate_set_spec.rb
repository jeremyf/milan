require 'spec_helper'
require 'milan/predicate_set'
require 'milan/predicate'

module Milan
  RSpec.describe PredicateSet do
    let(:predicate1) { Predicate.new(predicate: 'DC.title', attribute_method_name: 'title') }
    let(:predicate2) { Predicate.new(predicate: 'DC.abstract') }
    subject { PredicateSet.new(predicates: [predicate1, predicate2]) }

    its(:attribute_method_names) { should eq([predicate1.attribute_method_name, predicate2.attribute_method_name]) }
    it { should delegate_method(:each).to(:predicates) }
    it { should delegate_method(:length).to(:predicates) }
    it { should delegate_method(:size).to(:predicates) }

    context '#attribute_method_name_for' do
      it 'will fetch the predicate' do
        expect(subject.attribute_method_name_for('DC.title')).to eq(predicate1.attribute_method_name)
      end
    end
    context '#convert_attribute_name_to_predicate' do
      it 'will find the predicate for the attribute method name' do
        expect(subject.convert_attribute_name_to_predicate(predicate1.attribute_method_name)).to eq(predicate1)
      end
    end
    context '#fetch' do
      it 'will retrieve based on the predicate' do
        expect(subject.fetch('DC.title')).to eq(predicate1)
      end
      it 'will raise a KeyError if the key is not found' do
        expect { subject.fetch('title') }.to raise_error(KeyError)
      end
    end
    context '#[]' do
      it 'will retrieve based on the predicate' do
        expect(subject['DC.title']).to eq(predicate1)
      end
      it 'will return nil if the key is not found' do
        expect(subject['title']).to eq(nil)
      end
    end

    context '#key?' do
      it 'will return true if it exists' do
        expect(subject.key?('DC.title')).to eq(true)
      end
      it 'will return false if it does not exist' do
        expect(subject.key?('bogus')).to eq(false)
      end
    end
  end
end
