module Milan
  # The collection of terms
  class TermSet
    def initialize(terms:)
      self.terms = terms
    end

    include Enumerable
    extend Forwardable
    def_delegators :terms, :fetch, :[], :each, :size

    private

    attr_accessor :terms
  end
end
