require 'dry/equalizer'

module Milan
  # Responsible for containing the definition of a Predicate.
  #
  # This includes the name
  class Predicate
    include Dry::Equalizer(:to_h)

    def initialize(predicate:, **keywords)
      self.predicate = predicate
      self.keywords = keywords
    end

    def to_h
      keywords.merge(predicate: predicate)
    end

    attr_reader :predicate, :keywords
    alias name predicate

    def param_key
      keywords.fetch(:param_key, predicate)
    end

    private

    attr_writer :predicate, :keywords
  end
end
