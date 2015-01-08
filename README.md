# Sexy Settings

[![Dependency Status](https://gemnasium.com/romikoops/sexy_settings.png)](https://gemnasium.com/romikoops/sexy_settings)

Application settings are specified in a flexible way.

## What is Sexy Settings?

It is a Ruby-based library used to specify application settings in different ways:

* Using the YAML file (default and custom settings).
* Using the command line.

### What's new in 0.0.1

First version with the base functionality.

## Getting Started

### Prerequisites

It was tested with Ruby 1.9.2 but we expect it to also work with other Ruby versions
### Installation

>   gem install sexy_settings

### Configuration

Create 2 configuration files, one for default settings and the other one – for custom settings, e.g.:

```
config\
    default.yaml
    overwritten.yaml
```

  Insert the following code to the boot executable ruby file:

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

  Specify a shortcut method for the Settings object:

 ```ruby
 def settings
   SexySettings::Base.instance()
 end
 ```

### Usage

There are 4 possible settings values. The priority ranks with respect to the settings location are as follows:


> **command line** < **custom** < **default** < **nil**_(in case setting was not specified anywhere)_
> **command line** < **custom** < **default** < **nil**_(if the setting was not specified anywhere)_.

Thus, specifying some setting in the command line will override the same setting value specified in the <_default config file_> or <_custom config file_>

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

Set an environment variable:

> OPTIONS="foo2=10$$$foo3=:hi$$$foo4=true"

```ruby
puts settings.foo # returns 'bar'
puts settings.foo1 # returns 'custom foo'
puts settings.foo2 # returns 10
puts settings.foo3 # returns :hi
puts settings.foo4 # returns true
```


## Hints

* Add <_default config file_> under the version control system.
* Add <_custom config file_> to ignore the list.
*	Use the command line with an Environment Variable for fast specifying setting in your Continuous Integration System.
* Use the following code to output all settings as a pretty formatted text:

```ruby
puts settings.as_formatted_text
```
