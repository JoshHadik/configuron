require_relative '../lib/configuron'


RSpec.describe Configuron::Configurable do
  class Hello; end
  it "raises an unconfigurable type error when added to anything other than a module" do
    expect { Hello.extend(Configuron::Configurable) }.to raise_error(Configuron::Configurable::UnconfigurableTypeError)
  end
end
