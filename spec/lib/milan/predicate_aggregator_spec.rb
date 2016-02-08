require 'spec_helper'
require 'milan/predicate_aggregator'
require 'milan/predicate'

module Milan
  RSpec.describe PredicateAggregator do
    subject { described_class.new(predicates: [{ predicate: 'DC.title' }, { predicate: 'DC.abstract' }]) }

    context '#finalize' do
      subject { described_class.new(predicates: [{ predicate: 'DC.title' }, { predicate: 'DC.abstract' }]).finalize }
      context 'without additional predicate configuration' do
        it { should be_a(PredicateSet) }
        its(:size) { should eq(2) }

        it 'will expose retrieval method for predicate' do
          expect(subject.fetch('DC.title')).to eq(Predicate.new(predicate: 'DC.title'))
        end
      end
      context 'with additional configuration' do
        subject do
          described_class.new(predicates: [{ predicate: 'DC.title' }, { predicate: 'DC.abstract', cardinality: 'many' }]).tap do |obj|
            obj.append_additional_predicates_configurations(
              predicates: [
                { predicate: 'DC.title', cardinality: 1 }, { predicate: 'DC.hello' }, { predicate: 'DC.abstract', cardinality: 1 }
              ]
            )
          end.finalize
        end

        it { should be_a(PredicateSet) }
        its(:size) { should eq(2) }

        it 'will expose retrieval method for predicate' do
          expect(subject.fetch('DC.title')).to eq(Predicate.new(predicate: 'DC.title', cardinality: 1))
        end

        it 'will prefer direct definitions of additional predicate configurations' do
          expect(subject.fetch('DC.abstract')).to eq(Predicate.new(predicate: 'DC.abstract', cardinality: 'many'))
        end

        it 'will only register predicates that were part of the initialization' do
          expect { subject.fetch('DC.hello') }.to raise_error(KeyError)
        end
      end
    end
  end
end
