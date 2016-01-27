require 'spec_helper'
require 'milan/term_aggregator'

module Milan
  RSpec.describe TermAggregator do
    subject { described_class.new(terms: [{ term: 'DC.title' }, { term: 'DC.abstract' }]) }

    context '#finalize' do
      subject { described_class.new(terms: [{ term: 'DC.title' }, { term: 'DC.abstract' }]).finalize }
      context 'without additional term configuration' do
        it { should be_a(TermSet) }
        its(:size) { should eq(2) }

        it 'will expose retrieval method for term' do
          expect(subject.fetch('DC.title')).to eq(term: 'DC.title')
        end
      end
      context 'with additional configuration' do
        subject do
          described_class.new(terms: [{ term: 'DC.title' }, { term: 'DC.abstract', cardinality: 'many' }]).tap do |obj|
            obj.append_additional_terms_configurations(
              terms: [{ term: 'DC.title', cardinality: 1 }, { term: 'DC.hello' }, { term: 'DC.abstract', cardinality: 1 }]
            )
          end.finalize
        end

        it { should be_a(TermSet) }
        its(:size) { should eq(2) }

        it 'will expose retrieval method for term' do
          expect(subject.fetch('DC.title')).to eq(term: 'DC.title', cardinality: 1)
        end

        it 'will prefer direct definitions of additional term configurations' do
          expect(subject.fetch('DC.abstract')).to eq(term: 'DC.abstract', cardinality: 'many')
        end

        it 'will only register terms that were part of the initialization' do
          expect { subject.fetch('DC.hello') }.to raise_error(KeyError)
        end
      end
    end
  end
end
