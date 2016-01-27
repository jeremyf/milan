require "milan/version"
require 'milan/form_builder'

# A gem that provides an interface for building models via configuration.
module Milan
  # rubocop:disable Metrics/AbcSize
  # :reek:TooManyStatements: { exclude: [ 'Milan#self.form_for' ] }
  def self.form_for(work_type:, form:, config:)
    work_types = config.fetch(:work_types)
    work_type_config = work_types.find { |types| types.fetch(:work_type) == work_type }
    form_config = work_type_config.fetch(:forms).find { |obj| obj.fetch(:form) == form }
    FormBuilder.new(config: form_config) do
      append_additional_terms_configurations(terms: work_type_config.fetch(:terms)) if form_config.key?(:terms)
      append_additional_terms_configurations(terms: config.fetch(:terms)) if config.key?(:terms)
    end
  end
  # rubocop:enable Metrics/AbcSize
end
