require 'dry/equalizer'

module Milan
  # Responsible for containing the definition of a Term.
  #
  # This includes the name
  class Term
    include Dry::Equalizer(:to_h)

    def initialize(term:, **keywords)
      self.term = term
      self.keywords = keywords
    end

    def to_h
      keywords.merge(term: term)
    end

    attr_reader :term, :keywords
    alias name term

    def param_key
      keywords.fetch(:param_key, term)
    end

    private

    attr_writer :term, :keywords
  end
end
