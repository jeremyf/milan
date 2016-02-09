require 'i18n'

module Milan
  # Responsible for providing a consistent translation experience regarding predicates. The goal is to keep similar contexts close
  # together.
  module TranslationAssistant
    # Translate the given predicate based on the key fragments that are given.
    #
    # @param predicate [#translation_key_fragment]
    # @param key_fragments [Array<#to_s>]
    #
    # @example
    #   en:
    #     predicates:
    #       dc_title:
    #         ulra:
    #           label:
    #           hint:
    #           form:
    #             label:
    #             hint:
    #         label:
    #         hint:
    #         form:
    #           label:
    #           hint:
    #         display:
    #           label:
    #           hint:
    #
    # :reek:TooManyStatements: { exclude: [ 'Milan::TranslationAssistant#self.for_predicate' ] }
    def self.for_predicate(predicate:, key_fragments:, translator: default_translator)
      base_translation_key_fragment = predicate.translation_key_fragment
      key_fragments = [key_fragments].flatten.compact
      defaults = []
      key_fragments.each_index do |index|
        defaults << "#{base_translation_key_fragment}.#{key_fragments[index..-1].join('.')}".to_sym
      end
      defaults << base_translation_key_fragment
      attempted_key = defaults.shift
      translator.call(attempted_key, scope: 'predicates', default: defaults)
    end

    def self.default_translator
      I18n.method(:t)
    end

    private_class_method :default_translator
  end
end
