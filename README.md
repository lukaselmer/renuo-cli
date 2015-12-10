[![Build Status](https://travis-ci.org/renuo/renuo-cli.svg?branch=master)](https://travis-ci.org/renuo/renuo-cli)
[![Coverage Status](https://coveralls.io/repos/renuo/renuo-cli/badge.svg?branch=master&service=github)](https://coveralls.io/github/renuo/renuo-cli?branch=master)

# Renuo::Cli

The Renuo command line. Used for various (internal) stuff.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'renuo-cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install renuo-cli

## Usage

```sh
renuo -h
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Release

```sh
git flow release start [.....]
# adjust version.rb
bundle install
git commit -av
git flow release finish [.....]
git push origin develop:develop
git push origin master:master
git checkout master
bundle exec rake release
git checkout develop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/renuo/renuo-cli. This project is intended to
be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

