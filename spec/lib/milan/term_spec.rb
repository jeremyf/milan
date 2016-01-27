require 'spec_helper'
require 'milan/term'

module Milan
  RSpec.describe Term do
    subject { described_class.new(term: 'Hello', cardinality: 1) }
    its(:to_h) { should eq(term: 'Hello', cardinality: 1) }
    its(:name) { should eq('Hello') }
    its(:term) { should eq('Hello') }
  end
end
