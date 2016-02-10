require 'dry/equalizer'
require 'milan/registry'

module Milan
  # Responsible for containing the definition of a Predicate.
  #
  # @todo Factor the predicate translator into a separate object. Predicate should be a struct with little behavior. Its compressed out
  #   of convenience.
  class Predicate
    DEFAULT_CARDINALITY = "many".freeze
    DEFAULT_TYPE = "String".freeze

    # @api private
    # I'm not certain if we should assert equality based on the hash or on something at a more primative level.
    include Dry::Equalizer(:to_h)
    include Milan::Registry.inject(:predicate_translator)

    def initialize(predicate:, predicate_translator:, **keywords)
      super # becuase of the injection of predicate_translator
      self.predicate = predicate
      self.attribute_method_name = keywords.fetch(:attribute_method_name, predicate)
      self.translation_key_fragment = keywords.fetch(:translation_key_fragment, predicate)
      self.cardinality = keywords.fetch(:cardinality, DEFAULT_CARDINALITY)
      self.type = keywords.fetch(:type, DEFAULT_TYPE)
    end

    # There are a few aliased methods; I'm not including those as they are not a part of the constructor.
    def to_h
      {
        predicate: predicate, translation_key_fragment: translation_key_fragment, cardinality: cardinality,
        type: type, attribute_method_name: attribute_method_name
      }
    end

    # The name by which you call the predicate.
    #
    # @return String
    attr_reader :predicate

    # When this predicate is translated into different contexts, what is the translation key fragment.
    #
    # @return String
    # @see Milan::TranslationAssistant for more information
    attr_reader :translation_key_fragment

    # When we are working with values for this predicate what is the expected cardinality? Will we have 1, 2, or "many" entries?
    #
    # @return ["many", Number]
    # @see DEFAULT_CARDINALITY
    attr_reader :cardinality

    # When coercing the object portion of the triple (<subject><predicate><object>), what is the expected type for this given object
    #
    # @todo I believe, going forward, I want to make use of the dry-types gem (https://github.com/dryrb/dry-types)
    #
    # @see Milan::Predicate::DEFAULT_TYPE
    attr_reader :type

    alias name predicate

    # A string that can be used for the Ruby method name of this attribute. It is also suitable for use as the parameter key
    #
    # @example
    #   # Given Predicate#attribute_method_name == 'title'
    #   # Then rendering the input would be analog to the following:
    #
    #   ```html
    #   <input name="title">
    #   ```
    #
    #   ```json
    #   { "title": "Some Title" }
    #   ```
    #
    #   # There is an assumption that the param_keys can be nested; In Rails forms are submitted with a scoping hash key derived from
    #   # the model_name. So we might end up with `{ "book": { "title": "Some Title" } }`
    #
    # @return [String]
    # @note attribute_method_name is an alias of param_key, but is something that I don't want to overload in implementation.
    #   HTML input names are far more forgiving than Ruby method names.
    attr_reader :attribute_method_name
    alias param_key attribute_method_name

    private

    attr_writer :predicate, :translation_key_fragment, :cardinality, :type

    def attribute_method_name=(input)
      @attribute_method_name = Milan::Registry.resolve(:to_method_name, input)
    end

    # !@group Translations
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
    # !@endgroup
  end
end
