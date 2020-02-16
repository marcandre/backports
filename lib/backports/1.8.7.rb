# require this file to load all the backports of Ruby 1.8.7
require "backports/tools/require_relative_dir"
require "backports/tools/deprecation"

Backports.deprecate :require_version,
  'Requiring backports/<ruby version> is deprecated. Require just the needed backports instead'

Backports.deprecation_warned[:require_std_lib] = true
require "backports/std_lib"

Backports.require_relative_dir
