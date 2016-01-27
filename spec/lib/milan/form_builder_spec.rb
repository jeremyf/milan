require 'spec_helper'
require 'milan/form_builder'

module Milan
  RSpec.describe FormBuilder do
    let(:config) { { form: 'hello', terms: { term: 'ND.another_term' } } }
    let(:additional_terms) { { term: 'ND.expected_graduation_term', cardinality: 1 } }
    let(:term_aggregator) { double('Term Aggregator', append_terms: true) }
    subject { described_class.new(config: config, term_aggregator: term_aggregator) }

    its(:default_term_aggregator) { should respond_to(:append_terms) }
    it 'will append terms to the term aggregator during initialization' do
      additional_terms_scoped = additional_terms # establishing lexical scope
      described_class.new(config: config, term_aggregator: term_aggregator) { append_terms(additional_terms_scoped) }
      expect(term_aggregator).to have_received(:append_terms).with(additional_terms)
    end
  end
end
