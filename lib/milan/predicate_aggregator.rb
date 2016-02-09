require 'milan/container'

module Milan
  # Responsible for aggregating the configuration information for the given predicates
  class PredicateAggregator
    include Milan::Container.inject(:predicate_set_builder, :predicate_builder)

    def initialize(predicates:, predicate_set_builder:, predicate_builder:)
      super # required for the Container injection
      self.predicates = predicates
      self.additional_predicates_configurations = []
    end

    def append_additional_predicates_configurations(predicates:)
      additional_predicates_configurations << predicates
    end

    def finalize
      data = predicates.map { |predicate| build_configuration_for(predicate: predicate) }
      predicate_set_builder.call(predicates: data)
    end

    private

    attr_accessor :predicates, :additional_predicates_configurations

    # :reek:NestedIterators: { exclude: [ 'Milan::PredicateAggregator#build_configuration_for' ] }
    # :reek:TooManyStatements: { exclude: [ 'Milan::PredicateAggregator#build_configuration_for' ] }
    #
    # TODO: Extract a PredicateResolver based on the configuration
    def build_configuration_for(predicate:)
      key = predicate.fetch(:predicate)
      aggregate_predicate_config = [predicate]
      additional_predicates_configurations.each do |predicates_config|
        additional_predicate_config = predicates_config.find { |predicate_config| predicate_config.fetch(:predicate) == key }
        next unless additional_predicate_config
        aggregate_predicate_config.unshift(additional_predicate_config)
      end

      predicate_builder.call(**merge_predicate(aggregate_predicate_config))
    end

    # :reek:UtilityFunction: { exclude: [ 'Milan::PredicateAggregator#merge_predicate' ] }
    def merge_predicate(aggregate_predicate_config)
      aggregate_predicate_config.each_with_object({}) do |element, hash|
        hash.merge!(element)
        hash
      end
    end
  end
end
