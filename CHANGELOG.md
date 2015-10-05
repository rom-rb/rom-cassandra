## v0.1.0 to be released

### Changed (backward-incompatible)

* Switched to 'rom-migrator' implementation of migrations (nepalez)

### Deleted

* Rake task for migration to be implemented in 'rom-migrator' (nepalez)

### Internal

* `Gateway` isolates session (connection) from dataset (nepalez)
* `Session` is renamed to `Connection` (nepalez)

[Compare v0.0.2...v0.1.0](https://github.com/rom-rb/rom-cassandra/compare/v0.0.2...v0.1.0)

## v0.0.2 2015-09-08

### Changed

* Method `Commands#execute` takes argument instead of a block (nepalez)

[Compare v0.0.1...v0.0.2](https://github.com/rom-rb/rom-cassandra/compare/v0.0.1...v0.0.2)

## v0.0.1 2015-08-27

First public release
