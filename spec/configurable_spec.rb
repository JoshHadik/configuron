require_relative 'spec_helper'

RSpec.describe Configuron::Configurable, type: :unit do

  module ConfigurableModule
    extend Configuron::Configurable

    class Configuration
    end
  end

  let(:configurable_module) { ConfigurableModule }

  describe '.configuration' do
    it 'returns the modules configuration class' do
      expect(configurable_module.configuration).to be_an_instance_of(ConfigurableModule::Configuration).and be(configurable_module.configuration)
    end
  end

  describe '.reset!' do
    it 'resets the configuration object to a new instance' do
      expect { configurable_module.reset! }.to change { configurable_module.instance_variable_get(:@configuration)}
      expect(configurable_module.configuration).to be_an_instance_of(ConfigurableModule::Configuration)
    end
  end

  describe '.configure' do
    it 'yields its configuration class to the passed in block' do
      expect{ |spec| configurable_module.configure(&spec) }.to yield_with_args(configurable_module.configuration)
    end
  end
end
