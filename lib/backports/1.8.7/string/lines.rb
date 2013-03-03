require 'backports/tools'

Backports.alias_method String, :lines, :each_line
