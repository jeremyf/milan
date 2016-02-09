require 'dry/equalizer'
require 'milan/translation_assistant'

module Milan
  # Responsible for containing the definition of a Predicate.
  #
  # This includes:
  # * the name of the predicate
  # * the parameter key of the predicate (as used for HTML form submission)
  class Predicate
    DEFAULT_CARDINALITY = "many".freeze
    DEFAULT_TYPE = "String".freeze

    # @api private
    # I'm not certain if we should assert equality based on the hash or on something at a more primative level.
    include Dry::Equalizer(:to_h)

    def initialize(predicate:, predicate_translator: default_predicate_translator, **keywords)
      self.predicate = predicate
      self.keywords = keywords
      self.param_key = keywords.fetch(:param_key, predicate)
      self.translation_key_fragment = keywords.fetch(:translation_key_fragment, predicate)
      self.cardinality = keywords.fetch(:cardinality, DEFAULT_CARDINALITY)
      self.predicate_translator = predicate_translator
      self.type = keywords.fetch(:type, DEFAULT_TYPE)
    end

    def to_h
      {
        predicate: predicate, param_key: param_key, translation_key_fragment: translation_key_fragment, cardinality: cardinality,
        type: type
      }
    end

    attr_reader :predicate, :keywords, :translation_key_fragment, :cardinality, :param_key

    # When coercing the object portion of the triple (<subject><predicate><object>), what is the expected type for this given object
    #
    # @todo I believe, going forward, I want to make use of the dry-types gem (https://github.com/dryrb/dry-types)
    #
    # @see Milan::Predicate::DEFAULT_TYPE
    attr_reader :type
    alias name predicate

    private

    attr_writer :predicate, :keywords, :translation_key_fragment, :cardinality, :param_key, :type

    public

    def label(key_fragment = nil)
      translate(key_fragments: [key_fragment, :label])
    end

    def hint(key_fragment = nil)
      translate(key_fragments: [key_fragment, :hint])
    end

    # A mechanism for seeing all of the resolved translations for this predicate; Think of this as a debugging tool.
    def translations
      translate(key_fragments: [])
    end

    private

    def translate(key_fragments:)
      predicate_translator.call(predicate: self, key_fragments: key_fragments.flatten.compact)
    end

    attr_accessor :predicate_translator

    # :reek:UtilityFunction: { exclude: [ 'Milan::Predicate#default_predicate_translator' ] }
    def default_predicate_translator
      TranslationAssistant.method(:for_predicate)
    end
  end
end
