require 'spec_helper'
require 'milan/predicate_set'
require 'milan/predicate'

module Milan
  RSpec.describe PredicateSet do
    let(:predicate1) { Predicate.new(predicate: 'DC.title', attribute_method_name: 'title') }
    let(:predicate2) { Predicate.new(predicate: 'DC.abstract') }
    subject { PredicateSet.new(predicates: [predicate1, predicate2]) }

    its(:param_keys) { should eq([predicate1.param_key, predicate2.param_key]) }
    it { should delegate_method(:each).to(:predicates) }
    it { should delegate_method(:length).to(:predicates) }
    it { should delegate_method(:size).to(:predicates) }
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
