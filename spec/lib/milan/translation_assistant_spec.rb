require 'spec_helper'
require 'milan/translation_assistant'
require 'milan/predicate'

RSpec.describe Milan::TranslationAssistant do
  let(:predicate) { Milan::Predicate.new(predicate: 'dc_title') }
  let(:translator) { double(call: true) }
  context '.for_predicate' do
    it 'will call the translator with a handful of defaults' do
      key_fragments = [:form, :label]
      first_attempt = "#{predicate.predicate}.form.label".to_sym
      second_attempt = "#{predicate.predicate}.label".to_sym
      described_class.for_predicate(predicate: predicate, key_fragments: key_fragments, translator: translator)
      expect(translator).to have_received(:call).with(
        first_attempt, scope: 'predicates', default: [second_attempt, predicate.predicate]
      )
    end

    [
      {
        translations: { predicates: { dc_title: { label: 'Hello' } } }, key_fragments: 'label', expected: 'Hello'
      }, {
        translations: { predicates: { dc_title: { label: "Goodbye", form: { label: 'Hello' } } } },
        key_fragments: %w(form label), expected: 'Hello'
      }, {
        translations: { predicates: { dc_title: {} } }, key_fragments: %w(form label), expected: 'dc_title'
      }, {
        # This is a debugging scenario; I want to see what it all resolves to.
        translations: { predicates: { dc_title: { label: "Goodbye" } } }, key_fragments: [], expected: { label: "Goodbye" }
      }, {
        translations: { predicates: {} }, key_fragments: %w(form label), expected: 'dc_title'
      }
    ].each_with_index do |spec_config, index|
      it "translates scenario ##{index} (#{spec_config.inspect})" do
        I18n.config.enforce_available_locales = false
        I18n.backend = I18n::Backend::KeyValue.new({})
        I18n.backend.store_translations(:en, spec_config.fetch(:translations))
        key_fragments = spec_config.fetch(:key_fragments)
        expected_value = spec_config.fetch(:expected)
        expect(described_class.for_predicate(predicate: predicate, key_fragments: key_fragments)).to eq(expected_value)
      end
    end
  end
end
