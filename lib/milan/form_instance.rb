module Milan
  # A work in progress to implement an ActiveModel interface
  class FormInstance < BasicObject
    # A weak attempt at mirroring ActiveModel interface
    module Errors
      def self.[](_value)
        []
      end
    end
    private_constant :Errors

    def initialize(form_builder:, attributes: {})
      self.form_builder = form_builder
      # TODO: Need to keep only the predicates available for the form_builder
      self.attributes = attributes
    end

    def attribute_keys
      attributes.keys
    end

    # def singleton_class
    #   form_builder.singleton_class
    # end
    #
    # def valid?
    #   form_builder.valid?(attributes: attributes)
    # end

    def class
      form_builder.model_class
    end

    def model_name
      form_builder.model_name
    end

    def to_key
      nil
    end

    def to_param
      nil
    end

    def persisted?
      false
    end

    def errors
      Errors
    end

    def valid?
      true
    end

    alias send __send__

    def respond_to?(method_name, *)
      return true if attribute_keys.include?(method_name)
      return true if FormInstance.instance_methods.include?(method_name)
      false
    end

    def method_missing(method_name, *args, &block)
      attributes.fetch(method_name) { super }
    end

    def inspect
      "<#Milan::FormInstance attributes=#{attributes.inspect} form_builder=#{form_builder.inspect}"
    end

    alias to_s inspect

    private

    attr_accessor :form_builder, :attributes
  end
end
