require 'dry/container'
require 'dry/auto_inject'
require 'hanami/utils/string'

module Milan
  # A container module for registrations related to Milan. The idea is to provide a clear location for both defining interactions
  # as well as the means for doing dependency injection. I would love for more explicit interface definitions in the registry
  # but for now I'll settle with a consolidated location for that information.
  module Registry
    # :reek:TooManyStatements: { exclude: [ 'Milan::Registry#self.registration_container' ] }
    #
    # @todo I don't want to use the ||= as that is not a good thread safe pattern. Until I introduce an initializer (or use this in a
    # multi-threaded instance) this is adequate.
    def self.registration_container
      @registration_container ||= Dry::Container.new.tap do |container|
        container.register(:predicate_aggregate_builder) { Milan::PredicateAggregator.method(:new) }
        container.register(:predicate_builder) { Milan::Predicate.method(:new) }
        container.register(:predicate_set_builder) { Milan::PredicateSet.method(:new) }
        container.register(:predicate_translator) { Milan::TranslationAssistant.method(:for_predicate) }
        container.register(
          :to_method_name,
          ->(input) { Hanami::Utils::String.new(input.to_s.gsub(/\W+/, '_').sub(/\A_/, '')).underscore.chomp('_') }
        )
      end
    end
    private_class_method :registration_container

    def self.inject(*names, type: :hash)
      Dry::Injection.new(registration_container, type: type)[*names]
    end

    def self.resolve(name, *args, &block)
      resolver_for(name).call(*args, &block)
    end

    def self.resolver_for(name)
      registration_container.resolve(name)
    end
  end
end

# These are declared after the Milan::Registry module is defined. If the requires occur before the module definition the following error
# occurs:
# ```console
# ./milan/lib/milan/predicate.rb:18:in `<class:Predicate>': uninitialized constant Milan::Registry (NameError)
# ```
require 'milan/predicate'
require 'milan/predicate_set'
require 'milan/translation_assistant'
require 'milan/predicate_aggregator'
