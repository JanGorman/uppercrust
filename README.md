![Crust](https://dl.dropboxusercontent.com/u/512759/crust.png)

# Crust

Inspired by [jsonschema2pojo](https://github.com/joelittlejohn/jsonschema2pojo "jsonschema2pojo"), crust is your trusty companion to generate [Mantle](https://github.com/github/Mantle "Mantle") compatible model files in Objective-C.

Crust generates two header and two implementation files for each of your models. One set is prefixed with an underscore and is meant to be overwritten whenever the JSON schema changes. The files without underscore extends these classes and can be used to add custom functionality and custom mappings and should only be generated once.

## Installation

Add this line to your application's Gemfile:

    gem 'crust'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crust

## Usage

    $ crust generate --path {path} --base_only true|false
    
This generate an output folder with all the JSON files mapped to their Objective-C counterparts.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

* Add tests!
* Add some special types to the schema since Foundation has a richer vocabulary
* Wiki