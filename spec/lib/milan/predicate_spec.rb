require 'spec_helper'
require 'milan/predicate'

module Milan
  RSpec.describe Predicate do
    [
      {
        given: { predicate: 'title' },
        to_h: { predicate: 'title', cardinality: 'many', translation_key_fragment: 'title', param_key: 'title' }
      }, {
        given: { predicate: 'title', cardinality: 1, param_key: 'dc_title', translation_key_fragment: 'ulra.title' },
        to_h: {
          predicate: 'title', cardinality: 1, translation_key_fragment: 'ulra.title', param_key: 'dc_title'
        }
      }
    ].each_with_index do |spec_config, index|
      context "scenario ##{index} (#{spec_config.fetch(:given)})" do
        subject { described_class.new(spec_config.fetch(:given)) }
        its(:to_h) { should eq(spec_config.fetch(:to_h)) }
        its(:name) { should eq(spec_config.fetch(:given).fetch(:predicate)) }
      end
    end
  end
end
