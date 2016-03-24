require 'dry/validation'
require 'milan/utils'

module Milan
  # Responsible for exposing a mechanism for validation of a set of attributes
  # and the corresponding form builder (and its contracts)
  class Validator
    def self.call(**keywords)
      new(**keywords).call
    end

    def initialize(attributes:, form_builder:)
      self.form_builder = form_builder
      self.attributes = attributes
    end

    def call
      methods = build_schema_methods
      schema = build_schema_from(methods: methods)
      schema.call(attributes).messages
    end

    private

    attr_accessor :form_builder
    attr_reader :attributes

    def attributes=(input)
      @attributes = Milan::Utils.deep_stringify_keys(input)
    end

    # :reek:NestedIterators: { exclude: [ 'Milan::Validator#build_schema_methods' ] }
    # :reek:TooManyStatements: { exclude: [ 'Milan::Validator#build_schema_methods' ] }
    def build_schema_methods
      schema_methods = []
      form_builder.contracts.first.fetch(:validations).each do |validation|
        attribute_method_name = form_builder.attribute_method_name_for(validation.fetch(:key))
        validation.each_pair do |validation_method, _validation_options|
          next if validation_method == :key
          schema_methods << [attribute_method_name, validation_method]
        end
      end
      schema_methods
    end

    # :reek:NestedIterators: { exclude: [ 'Milan::Validator#build_schema_from' ] }
    def build_schema_from(methods:)
      given_methods = methods
      Dry::Validation::Schema() do
        given_methods.each do |key_name, validation_method|
          key(key_name).__send__(validation_method)
        end
      end
    end
  end
end
