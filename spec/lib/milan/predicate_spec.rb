require 'spec_helper'
require 'milan/predicate'

module Milan
  RSpec.describe Predicate do
    subject { described_class.new(predicate: 'Hello', cardinality: 1) }
    its(:to_h) { should eq(predicate: 'Hello', cardinality: 1) }
    its(:name) { should eq('Hello') }
    its(:predicate) { should eq('Hello') }

    context '#param_key' do
      it 'uses the param_key if one is given' do
        expect(described_class.new(predicate: 'Hello', cardinality: 1, param_key: 'hello_world').param_key).to eq('hello_world')
      end
      it 'uses the term if a param_key is not given' do
        expect(described_class.new(predicate: 'Hello', cardinality: 1).param_key).to eq('Hello')
      end
    end
  end
end
