module Milan
  # Responsible for containing the definition of a Term.
  #
  # This includes the name
  class Term
    def initialize(term:, **keywords)
      self.term = term
      self.keywords = keywords
    end

    def ==(other)
      other.to_h == to_h
    end

    def to_h
      keywords.merge(term: term)
    end

    attr_reader :term, :keywords
    alias name term

    private

    attr_writer :term, :keywords
  end
end
