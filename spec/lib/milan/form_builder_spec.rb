require 'spec_helper'
require 'milan/form_builder'
require 'milan/predicate_set'
require 'milan/predicate_aggregator'

module Milan
  RSpec.describe FormBuilder do
    let(:config) { { form: 'hello', predicates: [{ predicate: 'ND.another_term' }] } }
    let(:additional_predicates) { [{ predicate: 'ND.expected_graduation_term', cardinality: 1 }] }
    subject { described_class.new(config: config) }
    it 'will append predicates to the predicate aggregator during initialization' do
      expect_any_instance_of(PredicateAggregator).to(
        receive(:append_additional_predicates_configurations).with(predicates: additional_predicates).and_call_original
      )
      additional_predicates_scoped = additional_predicates # establishing lexical scope
      described_class.new(config: config) do
        append_additional_predicates_configurations(predicates: additional_predicates_scoped)
      end
    end
    its(:predicates) { should be_a(PredicateSet) }

    context '#new' do
      it 'builds a new form instance' do
        expect(subject.new(title: 'Tuesday').title).to eq('Tuesday')
      end
    end
  end
end
