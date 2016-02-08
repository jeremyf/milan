module Milan
  # The collection of predicates
  class PredicateSet
    def initialize(predicates:)
      self.predicates = predicates
    end

    include Enumerable
    extend Forwardable
    def_delegators :predicates, :each, :size, :length

    def fetch(term)
      self[term] || (raise KeyError, term)
    end

    def [](predicate)
      find { |element| element.predicate == predicate }
    end

    def param_keys
      map(&:param_key)
    end

    private

    attr_accessor :predicates
  end
end
