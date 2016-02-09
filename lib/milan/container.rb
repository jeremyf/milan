require 'dry/container'
require 'dry/auto_inject'
require 'milan/predicate_set'
require 'milan/predicate'

module Milan
  # @TODO Introduce thred safety and initializer behavior for Rails.
  module Container
    def self.container
      @container ||= Dry::Container.new.tap do |container|
        container.register(:predicate_aggregate_builder, -> { Milan::PredicateAggregator.method(:new) })
        container.register(:predicate_set_builder, Milan::PredicateSet.method(:new))
        container.register(:predicate_builder, Milan::Predicate.method(:new))
      end
    end
    private_class_method :container

    def self.inject(*names, type: :hash)
      Dry::Injection.new(container, type: type)[*names]
    end

    def self.call(name, *args, &block)
      resolver_for(name).call(*args, &block)
    end

    def self.resolver_for(name)
      container.resolve(name)
    end
  end
end
