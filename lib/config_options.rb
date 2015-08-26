require "yaml"

class ConfigOptions
  DEFAULT_CONFIG_FILE = "config/default.yml"

  def initialize(config)
    @custom_options = YAML.load(config.to_s) || {}
  end

  def to_yaml
    to_hash.to_yaml
  end

  def to_hash
    default_options.merge(custom_options)
  end

  private

  attr_reader :custom_options

  def default_options
    @default_config ||= YAML.load_file(DEFAULT_CONFIG_FILE)
  end
end
