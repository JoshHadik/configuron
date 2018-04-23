# Welcome to Configuron

Configuron is an extremely lightweight option for adding configurable behavior to a module. Rather than use a configuration hash, Configuron allows you to easily create a Configurable class that can be attached to your module.

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

## Getting Started

Using Configuron is easy! All you need to do is extend your own module with the Configuron Configurable module like so:

```ruby
module YourModule
  extend Configuron::Configurable
end
```
And then create a new Configuration class within the namespace of your module.

```ruby
class YourModule::Configuration
end
```

That's it! Configuron is all set up now! You now have access to three new methods that can be called on your module: configuration, configure, and reset!. Configuration allows you to access the new configuration class, configure allows you to set up the configuration class in block format, and reset! will reset the configuration class.

```ruby
YourModule.configuration
## Returns a stored instance of the Configuration class
```

```ruby
YourModule.configure do |config|
end
## Passes the stored instance of Configuration as config
```

```ruby
YourModule.reset!
## Deletes the stored instance of Configuration and replaces it with a new one
```

## Real World Example

To get a better idea of how all this works, let's take a look at a real world example.

One of the projects I'm working on right now is AlexaRailsKit, a platform that allows developers to integrate Amazon's Alexa with their rails application like never before! [As of the time of this writing AlexaRailsKit is not yet available.]

One of the features of AlexaRailsKit is the ability to easily protect your Skill's backend (which would be the rails app in this case) from foreign requests. Without a security measure like this, any developer that has access to a skill service's (the rails app) URL could easily set up their own Alexa Skill to interact with that application. To prevent this, Amazon attaches a Skill ID property to every single request made from Alexa. This Skill ID can then be matched against a list of pre-approved Skill ID's by the rails application to determine whether the request should be permitted or denied.

We wanted to add two configuration options to AlexaRailsKit to help protect against foreign requests:

1. The ability to add a pre-approved Skill ID.
2. The ability to allow all foreign requests. (usually just used in development)

To do this, we used Configuron. Here's how we did it:

### Step 1 - Set up the Module

```ruby
module AlexaRailsKit
  extend Configuron::Configurable
end
```

### Step 2 - Create the Configuration Class

We knew the configuration class needed four things:

1. An boolean variable to check if the developer specifically chose to allow foreign requests. (allow_foreign_requests)
2. A permitted skill ids array to store a list of all of the pre-approved skill ids. (permitted_skill_ids)
3. A method to change the allow foreign requests boolean to true. (allow_foreign_requests!)
4. A method to add a new skill id to the array of permitted skills. (add_permitted_skill_id)

Here's what we came up with:

```ruby
class AlexaRailsKit::Configuration
  attr_accessor :allows_foreign_requests, :permitted_skill_ids

  def initialize
    @allow_foreign_requests = false
    @permitted_skill_ids = []
  end

  def allow_foreign_requests!
    @allows_foreign_requests = true
  end

  def add_permitted_skill_id(skill_id)
    @permitted_skill_ids << skill_id
  end
end
```

### Step 3 - Verify requests

Our next step was to create a method to verify the requests. We chose to add this method on the AlexaRailsKit module.

The request verification method needed to do three things:

1. Accept the request's Skill ID as a paremeter.
2. Return true if the module was configured to allow foreign requests.
3. Return true if the requested Skill ID was included in the configuration classes permitted skills or false if it wasn't.

Here's how our module looked after we implemented it:

```ruby
module AlexaRailsKit
  extend Configuron::Configurable

  def self.verify_alexa_request(skill_id)
    return true if configuration.allows_foreign_requests
    return configuration.permitted_skill_ids.include? skill_id
  end
end
```

Notice how we were able to access the configuration object by just calling 'configuration' instead of '[ModuleName].configuration' like shown above. This is because we are accessing it on the same module that the class is defined on.

### Step 4 - Allow Developers to Configure AlexaRailsKit

Now that we had all the methods and configuration variables in place to handle request verification, the last step in the equation was to allow developers using AlexaRailsKit to configure these options. To do this, we simply added an AlexaRailsKit Initializer file to config/initializers which used Configuron's configure method like so:

```ruby
## config/initializer/alexa_rails_kit.rb
AlexaRailsKit.configure do |config|
end
```

Now, with all this in place, developers can easily configure AlexaRailsKit. if they want to add a permitted skill id, they can simply do this:

```ruby
## config/initializer/alexa_rails_kit.rb
AlexaRailsKit.configure do |config|
  config.add_permitted_skill_id "amazon.skill.12312.123.fake-skill-id"
end
```

Or to allow all foreign requests:

```ruby
## config/initializer/alexa_rails_kit.rb
AlexaRailsKit.configure do |config|
  config.allow_foreign_requests!
end
```

## Behind The Scenes

When you extend a module with the Configuron, Configuron uses instance_eval on the extended class to add the three methods, configuration, configure, and reset! You can look at the source code to see how we actually accomplish it, but the end result is the same as adding these three methods to your module:

```ruby
module YourModule

  def configuration
    @configuration ||= YourModule::Configuration.new
  end

  def reset!
    @configuration = YourModule::Configuration.new
  end

  def configure
    yield(configuration)
  end

end
```

## Build Status

[![Build Status](https://travis-ci.org/JoshHadik/Configuron.svg?branch=master)](https://travis-ci.org/JoshHadik/Configuron)
