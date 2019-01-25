# Welcome to Configuron

Configuron is an extremely lightweight option for adding configurable state to a module. Rather than use a configuration hash, Configuron allows you to easily create a Configuration class that can be attached to your module.

## Build Status

[![Build Status](https://travis-ci.org/JoshHadik/configuron.svg?branch=master)](https://travis-ci.org/JoshHadik/configuron)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'configuron'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install configuron
```

## What does it do?

Configuron allows you to easily create configurable modules, much like the ones you might see in a rails projects' config file:

```ruby
YourSuperCoolModule.configure do |config|
  config.path_to_something_awesome = "./lib/path/awesome.rb"
  config.block_stuff_thats_not_awesome!
end
```

## Why does it do it?

Sometimes when your building a module, in particular one that will be used by many different developers across many different projects, you want to allow for some amount of app-wide configuration.

For example, let's say you're building a Ruby Gem that helps developers build their own Card game, lets call it ruby_cards. The gem handles the logic of making a deck of cards, as well as gives developers a set of basic methods to interact with the deck (such as #shuffle or #deal).

The idea for 'ruby_cards' is that developers can expand on the built in logic of the gem to build their own card game. However, not all card games use the exact same state for a deck of cards. Some use jokers, some don't. Some consider aces a low card, some consider them high. Some use only one deck, some use many.

With Configuron, 'ruby_cards' could easily be setup to allow developers to handle that kind of game-specific configuration:

```ruby
RubyCards.configure do |config|
  config.enable_jokers!
  config.number_of_decks = 2
  config.consider_aces :high
end
```

## How can you use it?

Using Configuron is easy! All you need to do is extend your own module with the Configuron::Configurable module like so:

```ruby
module YourSuperCoolModule
  extend Configuron::Configurable
end
```
And then create a new Configuration class within the namespace of that module. Include all configuration state and methods inside of this class.

```ruby
class YourSuperCoolModule::Configuration
  attr_accessor :path_to_something_awesome, :allow_stuff_thats_not_awesome

  def initialize()
    @path_to_something_awesome = "/"
    @allow_stuff_thats_not_awesome = true
  end

  def block_stuff_thats_not_awesome!
    @allow_stuff_thats_not_awesome = false
  end
end
```

That's it! Configuron is all set up now! You now have access to three new methods that can be called on your module: '.configuration', '.configure', and '.reset!'.
'.configuration' returns the configuration class, '.configure' allows you to set up the configuration class in block format, and '.reset!' will reset the state of the configuration class.

```ruby
YourSuperCoolModule.configuration
## Returns a stored instance of the Configuration class
```

```ruby
YourSuperCoolModule.configure do |config|
  config.path_to_something_awesome = "./lib/path/awesome.rb"
  config.block_stuff_thats_not_awesome!
end
## Passes the stored instance of Configuration as config
```

```ruby
YourSuperCoolModule.reset!
## Deletes the stored instance of Configuration and replaces it with a new one
```

Once you have that setup, you can use the '.configuration' method throughout the logic of your modules code to access the state of the configuration:

```ruby
module YourSuperCoolModule
  def read_something_awesome
    File.read(YourSuperCoolModule.configuration.path_to_something_awesome
  end

  def handle_incoming_request(request)
    if !request.is_awesome?
      if YourSuperCoolModule.configuration.allow_stuff_thats_not_awesome
        # Allow non-awesome requests only if module is configured to allow it
        allow(request)
      else
        # Otherwise block not awesome requests
        block(request)
      end
    else
      # Always allow awesome requests
      allow(request)
    end
  end
end
```

## Putting it in practice

To get a better idea of how all this works, let's write some sample code. The goal of this sample will be to build part of the 'ruby_cards' gem example I gave above. In particular, we will be creating a RubyCards::Deck class that creates a deck of cards, and we will be implementing the configuration logic to choose whether or not to include jokers in the deck.

Let's start by setting up the RubyCards module, and making it extend from Configuron::Configurable:

```ruby
module RubyCards
  extend Configuron::Configurable
end
```

Next let's make a simple Card class that contains two attributes, a rank and a suit:

```ruby
class RubyCards::Card
  attr_reader :rank, :suit

  def initialize(rank, suit=false)
    @rank = rank
    @suit = suit
  end
end
```

Now lets make the RubyCards::Configuration class. For this we will want to set up three main components, an instance variable that keeps track of whether or not jokers are enabled (\@jokers_enabled) and defaults to false, a method to change the state of the \@jokers_enabled variable (#enable_jokers!), and a method to check whether or not jokers are enabled (#jokers_enabled?)

```ruby
class RubyCards::Configuration
  def initialize
    @jokers_enabled = false
  end

  def enable_jokers!
    @jokers_enabled = true
  end

  def jokers_enabled?
    return @jokers_enabled
  end
end
```

Finally, let's build the RubyCards::Deck class. This class will hold all of the cards for the deck in an instance variable called \@cards, and will seed the cards on initialization. We must also implement the logic to add jokers to the deck if and only if they have been enabled in the configuration.

```ruby
class RubyCards::Deck
  def initialize
    @cards = []
    add_cards
  end

  private

  def add_cards
    add_normal_playing_cards

    # only add jokers if they are enabled in the configuration.
    if RubyCards.configuration.jokers_enabled?
      add_jokers
    end
  end

  def add_normal_playing_cards
    ranks = [:one, :two, :three, :four, :five, :six, :seven
             :eight, :nine :ten, :jack, :queen, :king, :ace]
    suits = [:hearts, :spades, :clubs, :diamonds]

    ranks.each do |rank|
      suits.each do |suit|
        @cards << RubyCards::Card.new(rank, suit)
      end
    end
  end

  def add_jokers
    4.times do
      @cards << Ruby::Cards.new(:joker)
    end
  end
end
```

Now developers can easily choose whether to use jokers or not in their very own 'ruby_cards' card game:

```ruby
require 'ruby_cards'

RubyCards.configure do |config|
  # Use jokers in your card game built with 'ruby_cards'
  config.enable_jokers!
end
```

## Behind The Scenes (DIY)

When you extend a module with Configuron::Configurable, Configuron adds three methods, configuration, configure, and reset! to your module.

If you don't want to use configuron, but want the same functionality, you can easily 'roll your own' solution by adding the following three methods to the module you want to make configurable:

```ruby
module YourSuperCoolModule

  def self.configuration
    @configuration ||= YourSuperCoolModule::Configuration.new
  end

  def self.reset!
    @configuration = YourSuperCoolModule::Configuration.new
  end

  def self.configure
    yield(configuration)
  end

end
```
