# Sexy Settings

Flexible specifying of application settings

## What is Sexy Settings?

It is Ruby library for flexible specifying of application settings different ways:

* from YAML file(default and custom settings)
* from command line

### What's new in 0.0.1

Init version with base functionality

## Getting Started

### Prerequisites

It was tested with Ruby 1.9.2, but assumes it should work with other Ruby version as well
### Installation

>   gem install sexy_settings

### Configuration

 Create 2 configuration files, for default and custom settings. For instance,

>   config
    default.yaml
    overwritten.yaml

 Place next code to boot executable ruby file:

 ```ruby
 require 'sexy_settings'

 SexySettings.configure do |config|
   config.path_to_default_settings = File.expand_path("config.yaml", File.join(File.dirname(__FILE__), '..', 'config')) # 'default.yml' by default
   config.path_to_custom_settings = File.expand_path("overwritten.yaml", File.join(File.dirname(__FILE__), '..', 'config')) # 'custom.yml' by default
   config.path_to_project = File.dirname(__FILE__) # '.' by default
   config.env_variable_with_options = 'OPTIONS' # 'OPTS' by default
   cmd_line_option_delimiter = '$$$' # ',' by default
 end
 ```

 Specify shortcut method for Settings object:

 ```ruby
 def settings
   SexySettings::Base.instance()
 end
 ```

### Using

There are 4 possible values of settings
The priority ranks with respect to the setting places are as follows:

> **command line** < **custom** < **default** < **nil**_(in case setting was not specified anywhere)_

Thus, specifying some setting in command line will override the same setting value specified in <_default config file_> or <_custom config file_>

Example:

_default.yaml_

```yaml
  foo: bar
  foo1: default ${foo}
  foo2: default value
```

 _overwritten.yaml_

```yaml
  foo1: custom ${foo}
```

Set environment variable:

> OPTIONS="foo2=10$$$foo3=:hi$$$foo4=true"

```ruby
puts settings.foo # returns 'bar'
puts settings.foo1 # returns 'custom foo'
puts settings.foo2 # returns 10
puts settings.foo3 # returns :hi
puts settings.foo4 # returns true
```


## Hints

* Add <_default config file_> under version control system
* Add <_custom config file_> to ignore list
* Use command line with using Environment Variable for quick specifying setting in your Continuous Integration System
* Use next code for output all settings as pretty formatted text

```ruby
puts settings.as_formatted_text
```