require 'spec_helper'
require 'milan/term'

module Milan
  RSpec.describe Term do
    subject { described_class.new(term: 'Hello', cardinality: 1) }
    its(:to_h) { should eq(term: 'Hello', cardinality: 1) }
    its(:name) { should eq('Hello') }
    its(:term) { should eq('Hello') }
    its(:term) { should eq('Hello') }

    context '#param_key' do
      it 'uses the param_key if one is given' do
        expect(described_class.new(term: 'Hello', cardinality: 1, param_key: 'hello_world').param_key).to eq('hello_world')
      end
      it 'uses the term if a param_key is not given' do
        expect(described_class.new(term: 'Hello', cardinality: 1).param_key).to eq('Hello')
      end
    end
  end
end
