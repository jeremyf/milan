require 'spec_helper'
require 'milan/term_set'
require 'milan/term'

module Milan
  RSpec.describe TermSet do
    let(:term1) { Term.new(term: 'DC.title', param_key: 'title') }
    let(:term2) { Term.new(term: 'DC.abstract') }
    subject { TermSet.new(terms: [term1, term2]) }

    its(:param_keys) { should eq([term1.param_key, term2.param_key]) }

    context '#fetch' do
      it 'will retrieve based on the term' do
        expect(subject.fetch('DC.title')).to eq(term1)
      end
      it 'will raise a KeyError if the key is not found' do
        expect { subject.fetch('title') }.to raise_error(KeyError)
      end
    end
    context '#[]' do
      it 'will retrieve based on the term' do
        expect(subject['DC.title']).to eq(term1)
      end
      it 'will return nil if the key is not found' do
        expect(subject['title']).to eq(nil)
      end
    end
  end
end
