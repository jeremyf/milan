module Milan
  # Container for module function
  module Utils
    module_function

    # Convert keys to strings
    def stringify_keys(input)
      transform_hash(input) do |hash, key, value|
        hash[key.to_s] = value
      end
    end

    # Convert keys to strings, recursively
    def deep_stringify_keys(input)
      transform_hash(input, deep: true) do |hash, key, value|
        hash[key.to_s] = value
      end
    end

    def transform_hash(original, options = {}, &block)
      original.each_with_object({}) do |(key, value), result|
        value = if options[:deep] && value.is_a?(Hash)
                  transform_hash(value, options, &block)
                else
                  value
                end
        yield(result, key, value)
        result
      end
    end
    private_class_method :transform_hash
  end
end
