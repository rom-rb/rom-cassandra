ROM::Cassandra
==============

[![Gem Version](https://img.shields.io/gem/v/rom-cassandra.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/rom-rb/rom-cassandra/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/rom-rb/rom-cassandra.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/rom-rb/rom-cassandra.svg?style=flat)][codeclimate]
[![Coverage](https://img.shields.io/coveralls/rom-rb/rom-cassandra.svg?style=flat)][coveralls]
[![Inline docs](http://inch-ci.org/github/rom-rb/rom-cassandra.svg)][inch]

[builder]: https://github.com/nepalez/query_builder
[cassandra]: http://www.planetcassandra.org/
[codeclimate]: https://codeclimate.com/github/rom-rb/rom-cassandra
[coveralls]: https://coveralls.io/r/rom-rb/rom-cassandra
[driver]: https://github.com/datastax/ruby-driver
[gem]: https://rubygems.org/gems/rom-cassandra
[gemnasium]: https://gemnasium.com/rom-rb/rom-cassandra
[github]: https://github.com/rom-rb/rom-cassandra
[guide]: http://rom-rb.org/guides/adapters/cassandra/
[hexx-suit]: https://github.com/nepalez/hexx-suit
[inch]: https://inch-ci.org/github/rom-rb/rom-cassandra
[license]: LICENSE
[rom]: https://rom-rb.org
[rspec]: http://rspec.org
[travis]: https://travis-ci.org/rom-rb/rom-cassandra
[versions]: .travis.yml

[Apache Cassandra][cassandra] support for [Ruby Object Mapper][rom].

Based on the official datastax [ruby driver][driver] and [CQL query builder][builder].

Installation
------------

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem "rom-cassandra"
```

Then execute:

```
bundle
```

Or add it manually:

```
gem install rom-cassandra
```

Usage
-----

See the [corresponding Guide][guide] on rom-rb.org.

Compatibility
-------------

Compatible to ROM 0.9.1+, Cassandra Query Language v3 (CQL3), Apache Cassandra 1.2+.

Tested under [MRI and JRuby compatible to 1.9.3+][versions].

Uses [RSpec][rspec] 3.0+ for testing and [hexx-suit][hexx-suit] for dev/test tools collection.

Contributing
------------

* [Fork the project][github]
* Create your feature branch (`git checkout -b my-new-feature`)
* Add tests for it
* Run `rubocop` and `inch --pedantic` to ensure the style and inline docs are ok
* Run `rake mutant` or `rake exhort` to ensure 100% mutation testing coverage
* Commit your changes (`git commit -am '[UPDATE] Add some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create a new Pull Request

License
-------

See the [MIT LICENSE][license].
