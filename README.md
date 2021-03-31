# Backports Library [<img src="https://travis-ci.org/marcandre/backports.svg?branch=master">](https://travis-ci.org/marcandre/backports) [<img src="https://badge.fury.io/rb/backports.svg" alt="Gem Version" />](http://badge.fury.io/rb/backports) [![Tidelift](https://tidelift.com/badges/package/rubygems/backports)](https://tidelift.com/subscription/pkg/rubygems-backports?utm_source=rubygems-backports&utm_medium=referral&utm_campaign=readme)

Yearning to write a gem using some new cool features in Ruby 3.0 while
still supporting Ruby 2.5.x?
Have some legacy code in Ruby 1.8 but can't live without `flat_map`?

This gem is for you!

The goal of 'backports' is to make it easier to write ruby code that runs
across different versions of Ruby.

Note: [Next major version (X-mas
2021?)](https://github.com/marcandre/backports/issues/139) may drop support
for Ruby < 2.2.

## Loading backports

### Explicitly (recommended)

For example, if you want to use `transform_values` and `transform_keys`, even in
Ruby implementations that don't include it:

    require 'backports/2.4.0/hash/transform_values'
    require 'backports/2.5.0/hash/transform_keys'

This will enable `Hash#transform_values` and `Hash#transform_keys`, using the
native versions if available or otherwise provide a pure Ruby version.

### By Module

To bring all the backports for a given Class/Module, you can specify only that
Class:

    require 'backports/2.3.0/hash'

This will make sure that Hash responds to `dig`, `fetch_values`, `to_proc` and comparisons.

### Up to a specific Ruby version (for quick coding)

You can load all backports up to a specific version.
For example, to bring any version of Ruby mostly up to Ruby 3.0.0's standards:

    require 'backports/3.0.0'

This will bring in all the features of 1.8.7 and many features of Ruby 1.9.x
all the way up to Ruby 3.0.0 (for all versions of Ruby)!

You may `require 'backports/latest'` as a
shortcut to the latest Ruby version supported.

*Note*: For production / public gems, it is highly recommended you only require
the backports you need explicitly.

*Note*: Although I am a Ruby committer, this gem is a personal project and is
not endorsed by ruby-core.

## What's inside

Goals for backported features:
1.  Won't break older code
2.  Pure Ruby (no C extensions)
3.  Pass [ruby/spec](https://github.com/ruby/spec)

Let's be a bit more precise about the "breaking code" business. It is of
course entirely possible that code will break. In particular, you may be
distinguishing parameters with duck typing, but a builtin class may, in the
future, be responding to a particular call. Here's [an example from Rails][]
that is relying on the fact that Proc and Method respond to :to_proc and Hash
isn't. That is, until Ruby 2.3... This old version of Rails therefore won't
work on Ruby 2.3, or on older Rubies with that the `2.3.0/hash/to_proc`
loaded...

[an example from rails]: https://github.com/rails/rails/blob/a4b55827721a5967299f3c1531afb3d6d81e4ac0/activerecord/lib/active_record/associations/association.rb#L155-L159

For Ruby < 2.0, there are some real incompatibilities. For example,
`Module::instance_methods` which returns strings in 1.8 and symbols in 1.9. No
change can be made without the risk of breaking existing code. Such
incompatibilities are left unchanged, although you can require some of these
changes in addition (see below).

## Installation & compatibility

`backports` can be installed with:

    gem install backports

To use:

    require 'rubygems'
    # For only specific backports:
    require 'backports/1.9.1/kernel/require_relative'
    require 'backports/2.0.0/enumerable/lazy'

    # For all backports up to a given version
    require 'backports/1.9.2' # All backports for Ruby 1.9.2 and below

Note: about a dozen of backports have a dependency that will be also loaded.
For example, the backport of Enumerable#flat_map uses flatten(1), so if
required from Ruby 1.8.6 (where Array#flatten does not accept an argument),
the backport for Ruby's 1.8.7 flatten with an argument will also be loaded.

With bundler, add to your Gemfile:

    gem 'backports', :require => false

Run `bundle install` and require the desired backports. Compatible with Ruby
itself, JRuby and Rubinius.

# Complete List of backports

## Ruby 3.0 backports

#### Env
  - `except`

#### Hash
  - `except`
  - `transform_keys`, `transform_keys!` (with hash argument)

#### Ractor
  - All methods, with the caveats:
    - uses Ruby's `Thread` internally
    - will not raise some errors when `Ractor` would (in particular `Ractor::IsolationError`)
    - supported in Ruby 2.0+ only

#### Symbol
  - `name`

## Ruby 2.7 backports

#### Array
  - `intersection`

#### Comparable
  - `clamp` (with range)

#### Complex
  - `<=>`

#### Enumerable
  - `filter_map`
  - `tally`

#### Enumerator
  - `produce` (class method)

#### Time
  - `floor`, `ceil`

## Ruby 2.6 backports

#### Array
  - `difference`, `union`
  - `to_h` (with block)

#### Enumerable
  - `chain`
  - `to_h` (with block)

#### Enumerator::Chain (use Enumerable#chain)

#### Hash
  - `merge`, `merge!`/`update` (with multiple arguments)
  - `to_h` (with block)

#### Kernel
  - `then`

#### Method
  - `<<`, `>>`

#### Proc
  - `<<`, `>>`

#### Range
  - `cover?` (with `Range` argument)

## Ruby 2.5 backports

#### Array
  - `append`, `prepend`

#### Dir
  - `children`, `each_child`

#### Enumerable
  - `any?`, `all?`, `none?`, `one?` (with pattern argument)

#### Hash
  - `slice`
  - `transform_keys`

#### Integer
  - `sqrt`
  - `allbits?`, `anybits?` and `nobits?`

#### Kernel
  - `yield_self`

#### Module
  - `attr`, `attr_accessor`, `attr_reader`, `attr_writer` (now public)
  - `define_method`, `alias_method`, `undef_method`, `remove_method` (now
        public)

#### String
  - `delete_prefix`, `delete_prefix!`
  - `delete_suffix`, `delete_suffix!`
  - `undump`

#### Struct
  - `new` (with `keyword_init: true`)

## Ruby 2.4 backports

#### Comparable
  - `clamp`

#### Enumerable
  - `sum`
  - `uniq`

#### Hash
  - `compact`, `compact!`
  - `transform_values`, `transform_values!`

#### Queue
  - `close`, `closed?`

#### Regexp
  - `match?`

#### String
  - `match?`
  - `unpack1`

#### FalseClass, Fixnum, Bignum, Float, NilClass, TrueClass
  - `dup`

## Ruby 2.3 backports

#### Array
  - `bsearch_index`
  - `dig`

#### Enumerable
  - `chunk_while`
  - `grep_v`

#### Hash
  - `dig`
  - `fetch_values`
  - `to_proc`
  - <=, <, >=, >

#### Numeric
  - `negative?`
  - `positive?`

#### String
  - unary + and -

#### Struct
  - `dig`

## Ruby 2.2 backports

#### Enumerable
  - `slice_after`
  - `slice_when`

#### Float
  - `prev_float`
  - `next_float`

#### Kernel
  - `itself`

#### Method
  - `curry`
  - `super_method`

#### String
  - `unicode_normalize`
  - `unicode_normalize!`
  - `unicode_normalize?`

## Ruby 2.1 backports

#### Array
  - `to_h`

#### Bignum
  - `bit_length`

#### Enumerable
  - `to_h`

#### Fixnum
  - `bit_length`

#### Module
  - `include` (now public)

## Ruby 2.0 backports

#### Array
  - `bsearch`

#### Enumerable
  - `lazy`

#### Enumerator::Lazy
  - all methods

#### Hash
  - `default_proc=` (with nil argument)
  - `to_h`

#### `nil.to_h`

#### Range
  - `bsearch`

#### Struct
  - `to_h`

## Ruby 1.9.3 backports

#### File
  - `NULL`

#### IO
  - `advise` (acts as a noop)
  - `write`, `binwrite`

#### String
  - `byteslice`
  - `prepend`

## Ruby 1.9.2 backports

#### Array
  - `rotate, rotate!`
  - `keep_if, select!`
  - `product` (with block)
  - `repeated_combination`, `repeated_permutation`
  - `sort_by!`
  - `uniq, uniq!` (with block)

#### Complex
  - `to_r`

#### Dir
  - `home`

#### Enumerable
  - `chunk`
  - `flat_map`, `collect_concat`
  - `join`
  - `slice_before`

#### Float::INFINITY, NAN

#### Hash
  - `keep_if`, `select!`

#### Object
  - `singleton_class`

#### Random (new class)

*Note*: The methods of `Random` can't be required individually; the class
can only be required whole with `require 'backports/1.9.2/random'`.

## Ruby 1.9.1 backports

Additionally, the following Ruby 1.9 features have been backported:
#### Array
  - `try_convert`
  - `sample`

#### Enumerable
  - `each_with_object`
  - `each_with_index` (with arguments)

#### Enumerator
  - `new` (with block)

#### File
  - `binread`
  - `to_path`
  - All class methods accepting filenames will accept files or anything
        with a `#to_path` method.
  - `File.open` accepts an options hash.

#### Float
  - `round`

#### Hash
  - `assoc`, `rassoc`
  - `key`
  - `try_convert`
  - `default_proc=`

#### Integer
  - `magnitude`
  - `round`

#### IO
  - `bin_read`
  - `try_convert`
  - `ungetbyte`
  - `IO.open` accepts an options hash.

#### Kernel
  - `require_relative`

#### Math
  - `log` (with base)
  - `log2`

#### Numeric
  - `round`

#### Object
  - `define_singleton_method`
  - `public_method`
  - `public_send`

#### Proc
  - `yield`
  - `lambda?`
  - `curry`
  - `===`

#### Range
  - `cover?`

#### Regexp
  - `try_convert`

#### String
  - `ascii_only?`
  - `chr`
  - `clear`
  - `codepoints`, `each_codepoint`
  - `get_byte`, `set_byte`
  - `ord`
  - `try_convert`

`Enumerator` can be accessed directly (instead of `Enumerable::Enumerator`)

To include *only* these backports and those of the 1.8 line, `require
"backports/1.9.1"`.

Moreover, a pretty good imitation of `BasicObject` is available, but since it
is only an imitation, it must be required explicitly:

    require 'backports/basic_object'

## Ruby 1.8.7

Complete Ruby 1.8.7 backporting (core language). Refer to the official list of
[changes](https://github.com/ruby/ruby/blob/ruby_1_8_7/NEWS). That's about 130
backports!

Only exceptions:
#### String#gsub (the form returning an enumerator)
#### GC.stress=  (not implemented)
#### Array#choice (removed in 1.9, use 1.9.1's Array#sample instead)

## Libraries

Libraries were slowly being backported, but they are now available as separate gems.

The backports would be automatically used after requiring 'backports/std_lib' but this is now deprecated and discouraged.

The following libraries are up to date with Ruby 1.9.3:

#### Matrix
#### Prime
#### Set

The following library is to date with Ruby 2.0.0:

#### OpenStruct (ostruct)

I am aware of the following backport gem, which probably won't make it into
this gem:

#### Net::SMTP for Ruby 1.8.6:
    [smtp_tls](http://seattlerb.rubyforge.org/smtp_tls/)

Requiring backports for a given version of Ruby will also load
'backports/std_lib'.

## Forcing incompatibilities

Some backports would create incompatibilities in their current Ruby version
but could be useful in some projects. It is possible to request such
incompatible changes. Backports currently supports the following:

#### Hash
  - `select` (returns a Hash instead of an Array)

#### Enumerable / Array
  - `map` (returns an enumerator when called without a block)

#### String
  - `length`, `size` (for UTF-8 support)

These must be imported in addition to the backports gem, for example:

    require "backports/force/hash_select"
    {}.select{} # => {}, even in Ruby 1.8

## Thanks

Thanks for the bug reports and patches, in particular the repeat offenders:

#### Arto Bendiken ( [bendiken](http://github.com/bendiken) )
#### Konstantin Haase ( [rkh](https://github.com/rkh) )
#### Roger Pack ( [rdp](http://github.com/rdp) )
#### Victor Shepelev ( [zverok](http://github.com/zverok) )

## Contributing

The best way to submit a patch is to also submit a patch to
[ruby/spec](https://github.com/ruby/spec) and then a patch to backports that
make it pass the spec.

See below to test rubyspec. Note that only features missing from your Ruby
version are tested.

    git submodule init && git submodule update # => pulls rubyspecs
    bundle install
    bundle exec rake spec[hash/slice]          # => tests Hash#slice  (must be in Ruby 2.4 or less)
    bundle exec rake spec[hash/*]              # => tests all backported Hash methods
    bundle exec rake spec  (or rake spec[*/*]) # => all rubyspecs for backported methods

Failures that are acceptable are added the to `tags` file.

# License

`backports` is released under the terms of the MIT License, see the included
LICENSE file.

Author
:   Marc-André Lafortune

