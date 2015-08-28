require "spec_helper"
require "config_options"

describe ConfigOptions do
  describe "to_swiftlint_yaml" do
    it "excludes CUSTOM_KEYS from the output" do
      excluded_key = "custom_key"
      stub_const("ConfigOptions::CUSTOM_KEYS", [excluded_key])
      config = {
        "custom_key" => "key",
        "another_option" => "option",
      }.to_yaml
      config_options = ConfigOptions.new(config)

      yaml = config_options.to_swiftlint_yaml
      hash = YAML.load(yaml)

      expect(hash.keys).not_to include(excluded_key)
    end
  end
end
