require 'spec_helper'
require 'milan/form_instance'

module Milan
  RSpec.describe FormInstance do
    let(:model_name) { double('ModelName', human: 'Hello', singular: 'Hello', plural: 'Hello', to_str: 'Hello') }
    let(:form_builder) { double('FormBuilder', model_name: model_name, model_class: double(model_name: model_name)) }
    subject { described_class.new(form_builder: form_builder, attributes: {}) }
    context 'verifying the active model interface' do
      it 'will implement errors' do
        expect(subject).to respond_to(:errors)
        expect(subject.errors[:hello]).to be_a(Array)
      end

      it 'will have active model naming' do
        expect(subject.class).to respond_to(:model_name)
        expect(subject.model_name).to respond_to(:to_str)
        expect(subject.model_name.human).to respond_to(:to_str)
        expect(subject.model_name.singular).to respond_to(:to_str)
        expect(subject.model_name.plural).to respond_to(:to_str)
        expect(subject).to respond_to(:model_name)
        expect(subject.model_name).to eq(subject.class.model_name)
      end

      it 'will respond to #persisted?' do
        expect(subject).to respond_to(:persisted?)
      end

      it 'will implement #to_key' do
        expect(subject).to respond_to(:to_key)
        def subject.persisted?
          false
        end
        expect(subject.to_key).to eq(nil)
      end

      it 'will implement #to_param' do
        expect(subject).to respond_to(:to_param)
        def subject.to_key
          [1]
        end

        def subject.persisted?
          false
        end
        expect(subject.to_param).to eq(nil)
      end
    end
  end
end
