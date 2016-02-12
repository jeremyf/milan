require 'spec_helper'
require 'milan'

RSpec.describe Milan, type: :feature do
  context '.form_builder_for' do
    let(:requested_by) { double('Requester') }

    subject { described_class.form_builder_for(work_type: "ULRA Application", form: 'plan_of_study', config: config) }

    its(:partial_suffix) { should eq('plan_of_study') }
    it { should be_a(Milan::FormBuilder) }
    its(:contracts) { should eq(config.fetch(:work_types)[0].fetch(:forms)[0].fetch(:contracts)) }
    its(:predicates) { should be_a(Enumerable) }

    context 'that is used to build a form object' do
      subject do
        described_class.form_builder_for(work_type: "ULRA Application", form: 'description', config: config).new(title: 'Hello World')
      end
      its(:title) { should eq('Hello World') }
    end
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
          form: "plan_of_study",
          contracts: [{
            contexts: ['submit'],
            validations: [
              { validates: 'ND::expected_graduation_term', presence: true, inclusion: ["Summer 2016", "Fall 2016"] },
              { validates: 'ND::underclass_level', presence: true, inclusion: "ND::underclass_level/options" },
              { validates: 'ND::major', presence: true, inclusion: "https://nd.edu/api/majors.json" },
              { validates: 'ND::primary_college', presence: true }
            ]
          }],
          predicates: [
            { predicate: 'ND::expected_graduation_term' },
            { predicate: 'ND::underclass_level' },
            { predicate: 'ND::major' },
            { predicate: 'ND::minor' },
            { predicate: 'ND::primary_college' }
          ]
        }, {
          form: "description",
          contracts: [{
            contexts: ['submit'],
            validations: [
              { validates: 'DC::title', presence: true }
            ]
          }],
          predicates: [
            { predicate: 'DC::title' }
          ]
        }],
        display: [{
          regions: [
            { region: "description", predicates: [{ predicate: 'DC::title' }] },
            { region: "plan_of_study", using_form: 'plan_of_study' }
          ]
        }]
      }],
      predicates: [
        { predicate: 'DC::title', type: 'String', attribute_method_name: 'title' },
        {
          predicate: 'ND::underclass_level', options: ['First Year', 'Sophomore', 'Junior', 'Senior', '5th Year'],
          translation_key_fragment: 'ND::underclass_level'
        },
        { predicate: 'ND::expected_graduation_term', translation_key_fragment: 'ND::ulra.expected_graduation_term' },
        { predicate: 'ND::major', translation_key_fragment: 'ND::major' },
        { predicate: 'ND::minor', translation_key_fragment: 'ND::minor' },
        { predicate: 'ND::primary_college', translation_key_fragment: 'ND::primary_college', indexing_strategies: ['text'] }
      ]
    }
  end
end
