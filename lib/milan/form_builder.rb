require 'hanami/utils/string'
require 'milan/term_aggregator'

module Milan
  class FormBuilder
    def initialize(config:, term_aggregator: default_term_aggregator, &configuration_block)
      self.config = config
      self.name = config.fetch(:form)
      self.partial_suffix = config.fetch(:partial_suffix, name)
      self.term_aggregator = term_aggregator
      instance_exec(&configuration_block) if block_given?
    end
    attr_reader :name, :partial_suffix

    extend Forwardable
    def_delegator :term_aggregator, :append_terms

    def contracts
      config.fetch(:contracts)
    end

    private

    attr_writer :name
    attr_accessor :config, :term_aggregator

    def partial_suffix=(input)
      @partial_suffix = Hanami::Utils::String.new(input).underscore
    end

    def default_term_aggregator
      Milan::TermAggregator.new
    end
  end

  def self.form_for(work_type:, form:, config:)
    work_types = config.fetch(:work_types)
    work_type_config = work_types.find { |types| types.fetch(:work_type) }
    form_config = work_type_config.fetch(:forms).find { |obj| obj.fetch(:form) == form }
    FormBuilder.new(config: form_config) do
      append_terms(work_type_config.fetch(:terms)) if form_config.key?(:terms)
      append_terms(config.fetch(:terms)) if config.key?(:terms)
    end
  end
end
