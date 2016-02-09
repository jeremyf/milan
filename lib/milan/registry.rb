require 'dry/container'
require 'dry/auto_inject'
require 'milan/predicate_set'
require 'milan/predicate'

module Milan
  # A container module for registrations related to Milan. The idea is to provide a clear location for both defining interactions
  # as well as the means for doing dependency injection. I would love for more explicit interface definitions in the registry
  # but for now I'll settle with a consolidated location for that information.
  #
  # @todo Introduce thred safety and initializer behavior for Rails.
  module Registry
    def self.registration_container
      @registration_container ||= Dry::Container.new.tap do |container|
        container.register(:predicate_aggregate_builder, -> { Milan::PredicateAggregator.method(:new) })
        container.register(:predicate_set_builder, Milan::PredicateSet.method(:new))
        container.register(:predicate_builder, Milan::Predicate.method(:new))
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
