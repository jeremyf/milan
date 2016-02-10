require 'spec_helper'
require 'milan/predicate'

module Milan
  RSpec.describe Predicate do
    let(:predicate_translator) { double(call: true) }
    subject { described_class.new(predicate: 'title', predicate_translator: predicate_translator) }

    [:label, :hint].each do |method_name|
      context "##{method_name}" do
        it 'can be called without a parameter' do
          subject.public_send(method_name)
          expect(predicate_translator).to have_received(:call).with(predicate: subject, key_fragments: [method_name])
        end
        it "uses a single parameter to build the predicate_translator's key_fragments" do
          subject.public_send(method_name, :form)
          expect(predicate_translator).to have_received(:call).with(predicate: subject, key_fragments: [:form, method_name])
        end
      end
    end

    context '#translations' do
      it 'exposes a means of getting all of the contextual translations' do
        subject.translations
        expect(predicate_translator).to have_received(:call).with(predicate: subject, key_fragments: [])
      end
    end

    [
      {
        given: { predicate: 'dc:title' },
        to_h: {
          predicate: 'dc:title', cardinality: 'many', translation_key_fragment: 'dc:title', param_key: 'dc_title', type: 'String',
          attribute_method_name: 'dc_title'
        }
      }, {
        given: { predicate: 'title', cardinality: 1, param_key: 'dc_title', translation_key_fragment: 'ulra.title' },
        to_h: {
          predicate: 'title', cardinality: 1, attribute_method_name: 'dc_title', translation_key_fragment: 'ulra.title',
          param_key: 'dc_title', type: 'String'
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
      { left: { predicate: 'title', type: 'String' }, right: { predicate: 'title', type: 'Boolean' }, equality: false },
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

    it 'can initialize a new Predicate from the #to_h' do
      new_predicate = Predicate.new(subject.to_h)
      expect(new_predicate).to eq(subject)
      expect(new_predicate.object_id).to_not eq(subject.object_id)
    end
  end
end
