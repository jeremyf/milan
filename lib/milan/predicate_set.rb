module Milan
  # The collection of predicates and mechanisms for accessing them
  class PredicateSet
    def initialize(predicates:)
      self.predicates = predicates
    end

    include Enumerable
    extend Forwardable
    def_delegators :predicates, :each, :size, :length

    def fetch(name)
      self[name] || (raise KeyError, name)
    end

    def [](name)
      find { |element| element.name == name }
    end

    def key?(name)
      any? { |element| element.name == name }
    end

    def attribute_method_names
      map(&:attribute_method_name)
    end

    private

    attr_accessor :predicates
  end
end
