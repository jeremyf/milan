require 'hanami/utils/string'
require 'milan/predicate_aggregator'

module Milan
  # Responsible for building an object that can be used to build a form object.
  #
  # Think of this class as building another class-like object.
  class FormBuilder
    def initialize(config:, predicate_aggregate_builder: Milan::PredicateAggregator.method(:new), &configuration_block)
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

    attr_reader :predicates

    private

    attr_writer :name, :predicates
    attr_accessor :config, :predicate_aggregator

    def partial_suffix=(input)
      @partial_suffix = Hanami::Utils::String.new(input).underscore
    end
  end
end
