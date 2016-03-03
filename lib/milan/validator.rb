require 'active_support/concern'
require 'active_model/validator'
require 'active_model/validations'

module Milan
  # Responsible for exposing a mechanism for validation of a set of attributes
  # and the corresponding form builder (and its contracts)
  class Validator
    def initialize(attributes:, form_builder:)
      self.form_builder = form_builder
      self.attributes = attributes
    end

    def call
      form_builder.contracts.first.fetch(:validations).each do |validation|
        predicate_name = validation.fetch(:validates)
        predicate = form_builder.predicates.fetch(predicate_name)
        predicate.attribute_method_name
        validation.each_pair do |key, _validation_config|
          next if key == :validates
          validator_class_name = "ActiveModel::Validations::#{Hanami::Utils::String.new(key).classify}Validator"
          Kernel.const_get(validator_class_name)
        end
      end
    end

    private

    attr_accessor :attributes, :form_builder
  end
end
