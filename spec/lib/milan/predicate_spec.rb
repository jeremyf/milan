require 'spec_helper'
require 'milan/predicate'

module Milan
  RSpec.describe Predicate do
    let(:translator) { double(call: true) }
    subject { described_class.new(predicate: 'title', translator: translator) }
    its(:default_translator) { should respond_to(:call) }

    [:label, :hint].each do |method_name|
      context "##{method_name}" do
        it 'can be called without a parameter' do
          subject.public_send(method_name)
          expect(translator).to have_received(:call).with(predicate: subject, key_fragments: [method_name])
        end
        it "uses a single parameter to build the translator's key_fragments" do
          subject.public_send(method_name, :form)
          expect(translator).to have_received(:call).with(predicate: subject, key_fragments: [:form, method_name])
        end
      end
    end

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
      context "scenario ##{index} (#{spec_config.fetch(:given).inspect})" do
        subject { described_class.new(spec_config.fetch(:given)) }
        its(:to_h) { should eq(spec_config.fetch(:to_h)) }
        its(:name) { should eq(spec_config.fetch(:given).fetch(:predicate)) }
      end
    end

    [
      { left: { predicate: 'title' }, right: { predicate: 'title' }, equality: true },
      { left: { predicate: 'title', cardinality: 1 }, right: { predicate: 'title' }, equality: false }
    ].each_with_index do |spec_config, index|
      left = spec_config.fetch(:left)
      right = spec_config.fetch(:right)
      equality = spec_config.fetch(:equality)
      it "considers #{left} to #{equality ? '' : 'NOT '}equal #{right.inspect} (Scenario #{index})" do
        left_predicate = described_class.new(left)
        right_predicate = described_class.new(right)
        expect(left_predicate.to_h == right_predicate.to_h).to eq(equality)
        expect(left_predicate == right_predicate).to eq(equality)
        expect(left_predicate.eql?(right_predicate)).to eq(equality)

        # The more tightly defined equal? should never be true; They are not the same object in memory
        expect(left_predicate.equal?(right_predicate)).to eq(false)
      end
    end
  end
end
