require 'spec_helper'
require 'milan/form_builder'

module Milan
  RSpec.describe FormBuilder do
    let(:config) { { form: 'hello', terms: [{ term: 'ND.another_term' }] } }
    let(:additional_terms) { [{ term: 'ND.expected_graduation_term', cardinality: 1 }] }
    subject { described_class.new(config: config) }
    it 'will append terms to the term aggregator during initialization' do
      expect_any_instance_of(TermAggregator).to receive(:append_additional_terms_configurations).with(terms: additional_terms).
        and_call_original
      additional_terms_scoped = additional_terms # establishing lexical scope
      described_class.new(config: config) do
        append_additional_terms_configurations(terms: additional_terms_scoped)
      end
    end
  end
end
