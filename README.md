# Welcome to Configuron
Configuron is an extremely lightweight option for adding configurable behavior to a module. To use it, simple extend the configurable module in your own module like so:

```ruby
module YourModule
  extend Configuron::Configurable
end
```
And then create a new Configuration class within the namespace of your module.

```ruby
class YourModule::Configuration
  extend Configuron::Configurable
end
```


## Installation
Add this line to your application's Gemfile:



And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install alexa_ruby
```
