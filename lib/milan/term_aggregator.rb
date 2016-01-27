module Milan
  # Responsible for aggregating the configuration information for the given terms
  class TermAggregator
    def initialize(terms:)
      self.terms = terms
      self.additional_terms_configurations = []
    end

    def append_additional_terms_configurations(terms:)
      additional_terms_configurations << terms
    end

    def finalize
      terms.each_with_object({}) do |term, obj|
        obj[term.fetch(:term)] = build_configuration_for(term: term)
        obj
      end.freeze
    end

    private

    attr_accessor :terms, :additional_terms_configurations

    def build_configuration_for(term:)
      key = term.fetch(:term)
      aggregate_config = [term]
      additional_terms_configurations.each do |terms_config|
        additional_config = terms_config.find { |term_config| term_config.fetch(:term) == key }
        next unless additional_config
        aggregate_config.unshift(additional_config)
      end
      aggregate_config.each_with_object({}) do |element, hash|
        hash.merge!(element)
        hash
      end
    end
  end
end
