module Milan
  # The collection of terms
  class TermSet
    def initialize(terms:)
      self.terms = terms
    end

    include Enumerable
    extend Forwardable
    def_delegators :terms, :each, :size, :length

    def fetch(term)
      self[term] || (fail KeyError, term)
    end

    def [](term)
      find { |element| element.term == term }
    end

    def param_keys
      map(&:param_key)
    end

    private

    attr_accessor :terms
  end
end
