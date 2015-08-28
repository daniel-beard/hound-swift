require "yaml"

class ConfigOptions
  DEFAULT_CONFIG_FILE = "config/default.yml"
  CUSTOM_KEYS = ["version"]

  def initialize(config = "")
    @custom_options = YAML.load(config || "") || {}
  end

  def to_swiftlint_yaml
    hash = to_hash.delete_if { |key, _| CUSTOM_KEYS.include?(key) }
    hash.to_yaml
  end

  def to_hash
    default_options.merge(custom_options)
  end

  def version
    to_hash.fetch("version", ENV.fetch("SWIFT_LINT_VERSION"))
  end

  private

  attr_reader :custom_options

  def default_options
    @default_config ||= YAML.load_file(DEFAULT_CONFIG_FILE)
  end
end
