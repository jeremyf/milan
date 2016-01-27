require 'hanami/utils/string'
module Milan
  class FormBuilder
    def initialize(config:)
      self.config = config
      self.name = config.fetch(:form)
      self.partial_suffix = config.fetch(:partial_suffix, name)
    end
    attr_reader :name, :partial_suffix

    def new(context:, requested_by:, attributes:)
    end

    def contracts
      config.fetch(:contracts)
    end

    private

    attr_writer :name
    attr_accessor :config

    def partial_suffix=(input)
      @partial_suffix = Hanami::Utils::String.new(input).underscore
    end
  end

  def self.form_for(work_type:, form:, config:)
    work_types = config.fetch(:work_types)
    work_type_config = work_types.find { |types| types.fetch(:work_type) }
    form_config = work_type_config.fetch(:forms).find { |obj| obj.fetch(:form) == form }
    FormBuilder.new(config: form_config)
  end
end
