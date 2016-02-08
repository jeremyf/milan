require 'spec_helper'
require 'milan'

RSpec.describe Milan, type: :feature do
  context '.form_for' do
    let(:context) { double('The Context for the Form') }
    let(:requested_by) { double('Requester') }

    subject { described_class.form_for(work_type: "ULRA Application", form: 'Plan of Study', config: config) }

    its(:partial_suffix) { should eq('plan_of_study') }
    it { should be_a(Milan::FormBuilder) }
    its(:contracts) { should eq(config.fetch(:work_types)[0].fetch(:forms)[0].fetch(:contracts)) }
    its(:predicates) { should be_a(Enumerable) }
  end

  let(:config) do
    {
      work_types: [{
        work_type: "ULRA Application",
        contracts: [{
          contexts: "ingest",
          validations: [{ validator: 'Sipity::Contracts::IngestContract' }]
        }],
        forms: [{
          form: "Plan of Study",
          contracts: [{
            contexts: ['submit'],
            validations: [
              { validates: 'ND.expected_graduation_term', presence: true, inclusion: "ND.expected_graduation_term/options" },
              { validates: 'ND.underclass_level', presence: true, inclusion: "ND.underclass_level/options" },
              { validates: 'ND.major', presence: true },
              { validates: 'ND.primary_college', presence: true, cardinality: 1 }
            ]
          }],
          predicates: [
            { predicate: 'ND.expected_graduation_term', cardinality: 1 },
            { predicate: 'ND.underclass_level' },
            { predicate: 'ND.major', cardinality: 'many' },
            { predicate: 'ND.minor', cardinality: 'many' },
            { predicate: 'ND.primary_college', cardinality: 1 }
          ]
        }],
        predicates: [{
          predicate: 'ND.primary_college', cardinality: 1,
          label: 'Primary College'
        }]
      }],
      predicates: [{
        predicate: 'ND.underclass_level', options: ['First Year', 'Sophomore', 'Junior', 'Senior', '5th Year'], cardinality: 1
      }]
    }
  end
end
