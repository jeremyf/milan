require 'spec_helper'
require 'milan/predicate'

module Milan
  RSpec.describe Predicate do
    subject { described_class.new(predicate: 'Hello', cardinality: 1) }
    its(:to_h) { should eq(predicate: 'Hello', cardinality: 1, translation_key_fragment: 'Hello', param_key: 'Hello') }
    its(:name) { should eq('Hello') }
    its(:predicate) { should eq('Hello') }
  end
end
