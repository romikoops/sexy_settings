# Sexy Settings

[![Build Status](https://travis-ci.org/romikoops/sexy_settings.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/romikoops/sexy_settings.png)][gemnasium]

[travis]: https://travis-ci.org/romikoops/sexy_settings
[gemnasium]: https://gemnasium.com/romikoops/sexy_settings
(https://gemnasium.com/romikoops/sexy_settings)

Application settings are specified in a flexible way.

## What is Sexy Settings?

It is a Ruby-based library used to specify application settings in different ways:

* Using the YAML file (default and custom settings).
* Using the command line.

### What's new in 0.0.3

- Stop supporting Ruby < 2.2.2
- Fixed issue [Exception on empty custom.yml](https://github.com/romikoops/sexy_settings/issues/6)

### What's new in 0.0.2

- Ability to override delimiter on fly for command line settings
- Hidden sensitive data in logging
- Changed default environment variable name with options

## Getting Started

### Prerequisites

Ruby 2.2.2+

### Installation

>   gem install sexy_settings

### Configuration

Create 2 configuration files, one for default settings and the other one – for custom settings, e.g.:

```
config\
    default.yml
    custom.yml
```

  Insert the following code to the boot executable ruby file:

 ```ruby
 require 'sexy_settings'
 ```

  Specify a shortcut method for the Settings object:

 ```ruby
 def settings
   SexySettings::Base.instance
 end
 ```

### Usage

There are 4 possible settings values. The priority ranks with respect to the settings location are as follows:


> **command line** < **custom** < **default** < **nil**_(in case setting was not specified anywhere)_

Thus, specifying some setting in the command line will override the same setting value specified in the <_default config file_> or <_custom config file_>

Example:

_default.yml_

```yaml
  foo: bar
  foo1: default ${foo}
  foo2: default value
```

 _custom.yml_

```yaml
  foo1: custom ${foo}
```

Set an environment variable:

> SEXY_SETTINGS="foo2=10,foo3=:hi,foo4=true"

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
* Specify custom delimiter with  SEXY_SETTINGS_DELIMITER environment variable in case you need unique delimiter for command line mode
* Use the following code to output all settings as a pretty formatted text:
```ruby
puts settings.as_formatted_text
```
__Note__, all sensitive data will be masked.

## Advanced settings

You have ability to change some default settings:

```ruby
SexySettings.configure do |config|
   config.path_to_default_settings = File.expand_path("config.yaml", File.join(File.dirname(__FILE__), '..', 'config')) # 'default.yml' by default
   config.path_to_custom_settings = File.expand_path("overwritten.yaml", File.join(File.dirname(__FILE__), '..', 'config')) # 'custom.yml' by default
   config.path_to_project = File.dirname(__FILE__) # '.' by default
   config.env_variable_with_options = 'OPTIONS' # 'SEXY_SETTINGS' by default
   cmd_line_option_delimiter = '$$$' # ',' by default
end
```

Contributing
------------

Please see [CONTRIBUTING.md](https://github.com/romikoops/sexy_settings/blob/master/CONTRIBUTING.md).

SexySettings was originally designed and is now maintained by Roman Parashchenko. You can find list of contributors here [open source
community](https://github.com/romikoops/sexy_settings/graphs/contributors).

License
-------

SexySettngs is Copyright © 2011-2017 Roman Parashchenko. It is free
software, and may be redistributed under the terms specified in the
[LICENSE](/LICENSE_MIT) file.
