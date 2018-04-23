require_relative '../lib/configuron'

require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov


RSpec.describe Configuron::Configurable do
  class Hello; end
  it "will raise an unconfigurable type error when added to anything other than a module" do
    expect { Hello.extend(Configuron::Configurable) }.to raise_error(Configuron::Configurable::UnconfigurableTypeError)
  end
end
