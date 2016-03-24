require 'spec_helper'
require 'milan/validator'
require 'milan/form_builder'

RSpec.describe Milan::Validator do
  let(:form_builder) { Milan::FormBuilder.new(config: config) }
  let(:config) do
    {
      form: "description",
      contracts: [{
        contexts: ['submit'],
        validations: [{ key: 'DC::title', required: true }]
      }],
      predicates: [
        { predicate: 'DC::title', attribute_method_name: 'title', type: 'String' }
      ]
    }
  end
  it 'will return an empty array when the data is valid' do
    validator = described_class.new(attributes: { title: 'Hello' }, form_builder: form_builder)
    expect(validator.call).to eq({})
  end
  it 'will return a non-empty array when the data is invalid' do
    validator = described_class.new(attributes: { title: '' }, form_builder: form_builder)
    expect(validator.call).to eq("title" => ["must be filled"])
  end
end
