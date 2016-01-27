module Milan
  class FormInstance < BasicObject
    class Errors
      def [](value)
        []
      end
    end
    private_constant :Errors

    def initialize(form_builder:, attributes:)
      self.form_builder = form_builder
      self.attributes = attributes
    end

    def singleton_class
      form_builder.singleton_class
    end

    def valid?
      form_builder.valid?(attributes: attributes)
    end

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
      Errors.new
    end

    def respond_to?(method_name, all_methods = false)
      return true if FormInstance.instance_methods.include?(method_name)
      return true if all_methods && FormInstance.private_instance_methods.include?(method_name)
      return true if all_methods && FormInstance.protected_instance_methods.include?(method_name)
      return true if attribute_keys.include?(method_name)
      return true if attribute_keys.include?(method_name.to_s)
      false
    end

    def inspect
      "<#Milan::FormInstance attributes=#{attributes.inspect}"
    end

    alias to_s inspect

    private

    attr_accessor :form_builder, :attributes

  end
end
