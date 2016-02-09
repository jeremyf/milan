require 'hanami/utils/string'
require 'milan/registry'
require 'milan/form_instance'

module Milan
  # Responsible for building an object that can be used to build a form object.
  #
  # Think of this class as building another class-like object.
  class FormBuilder
    include Milan::Registry.inject(:predicate_aggregate_builder)

    def initialize(config:, predicate_aggregate_builder:, &configuration_block)
      self.config = config
      self.name = config.fetch(:form)
      self.partial_suffix = config.fetch(:partial_suffix, name)
      self.predicate_aggregator = predicate_aggregate_builder.call(predicates: config.fetch(:predicates))
      instance_exec(&configuration_block) if block_given?
      self.predicates = predicate_aggregator.finalize
    end
    attr_reader :name, :partial_suffix

    extend Forwardable
    def_delegator :predicate_aggregator, :append_additional_predicates_configurations
    private :append_additional_predicates_configurations

    def contracts
      config.fetch(:contracts)
    end

    def new(**keywords)
      # TODO: Take the intersection of the given keywords keys and the predicates.param_keys
      Milan::FormInstance.new(form_builder: self, **keywords)
    end

    attr_reader :predicates

    private

    attr_writer :name, :predicates
    attr_accessor :config, :predicate_aggregator

    def partial_suffix=(input)
      @partial_suffix = Hanami::Utils::String.new(input).underscore
    end
  end
end
