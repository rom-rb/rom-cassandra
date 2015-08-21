[WIP] ROM::Cassandra
====================

[![Gem Version](https://img.shields.io/gem/v/rom-cassandra.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/rom-rb/rom-cassandra/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/rom-rb/rom-cassandra.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/rom-rb/rom-cassandra.svg?style=flat)][codeclimate]
[![Coverage](https://img.shields.io/coveralls/rom-rb/rom-cassandra.svg?style=flat)][coveralls]
[![Inline docs](http://inch-ci.org/github/rom-rb/rom-cassandra.svg)][inch]

[codeclimate]: https://codeclimate.com/github/rom-rb/rom-cassandra
[coveralls]: https://coveralls.io/r/rom-rb/rom-cassandra
[gem]: https://rubygems.org/gems/rom-cassandra
[gemnasium]: https://gemnasium.com/rom-rb/rom-cassandra
[travis]: https://travis-ci.org/rom-rb/rom-cassandra
[inch]: https://inch-ci.org/github/rom-rb/rom-cassandra

[Apache Cassandra] support for [Ruby Object Mapper].

Based on the official datastax [ruby driver] and [query_builder] CQL constructor.

[Apache Cassandra]: http://www.planetcassandra.org/
[Ruby Object Mapper]: https://rom-rb.org
[ruby driver]: https://github.com/datastax/ruby-driver
[query_builder]: https://github.com/nepalez/query_builder

Synopsis
--------

@todo

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

Compatibility
-------------

Compatible to ROM 0.8+, Cassandra Query Language v3 (CQL3), Apache Cassandra 1.2+.

Tested under rubies [compatible to MRI 1.9.3+](.travis.yml).

Uses [RSpec] 3.0+ for testing and [hexx-suit] for dev/test tools collection.

[RSpec]: http://rspec.org
[hexx-suit]: https://github.com/nepalez/hexx-suit

Contributing
------------

* [Fork the project](https://github.com/rom-rb/rom-cassandra)
* Create your feature branch (`git checkout -b my-new-feature`)
* Add tests for it
* Run `rubocop` and `inch --pedantic` to ensure the style and inline docs are ok
* Run `rake mutant` or `rake exhort` to ensure 100% mutation testing coverage
* Commit your changes (`git commit -am '[UPDATE] Add some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create a new Pull Request

License
-------

See the [MIT LICENSE](LICENSE).
