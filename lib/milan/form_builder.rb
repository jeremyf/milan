require 'hanami/utils/string'
require 'milan/term_aggregator'

module Milan
  # Responsible for building an object that can be used to build a form object.
  #
  # Think of this class as building another class-like object.
  class FormBuilder
    def initialize(config:, term_aggregate_builder: Milan::TermAggregator.method(:new), &configuration_block)
      self.config = config
      self.name = config.fetch(:form)
      self.partial_suffix = config.fetch(:partial_suffix, name)
      self.term_aggregator = term_aggregate_builder.call(terms: config.fetch(:terms))
      instance_exec(&configuration_block) if block_given?
      self.terms = term_aggregator.finalize
    end
    attr_reader :name, :partial_suffix

    extend Forwardable
    def_delegator :term_aggregator, :append_additional_terms_configurations
    private :append_additional_terms_configurations

    def contracts
      config.fetch(:contracts)
    end

    attr_reader :terms

    private

    attr_writer :name, :terms
    attr_accessor :config, :term_aggregator

    def partial_suffix=(input)
      @partial_suffix = Hanami::Utils::String.new(input).underscore
    end
  end
end
