require 'dry/equalizer'

module Milan
  # Responsible for containing the definition of a Predicate.
  #
  # This includes:
  # * the name of the predicate
  # * the parameter key of the predicate (as used for HTML form submission)
  class Predicate
    DEFAULT_CARDINALITY = "many".freeze

    include Dry::Equalizer(:to_h)

    def initialize(predicate:, **keywords)
      self.predicate = predicate
      self.keywords = keywords
      self.param_key = keywords.fetch(:param_key, predicate)
      self.translation_key_fragment = keywords.fetch(:translation_key_fragment, predicate)
      self.cardinality = keywords.fetch(:cardinality, DEFAULT_CARDINALITY)
    end

    def to_h
      { predicate: predicate, param_key: param_key, translation_key_fragment: translation_key_fragment, cardinality: cardinality }
    end

    attr_reader :predicate, :keywords, :translation_key_fragment, :cardinality, :param_key
    alias name predicate

    private

    attr_writer :predicate, :keywords, :translation_key_fragment, :cardinality, :param_key
  end
end
