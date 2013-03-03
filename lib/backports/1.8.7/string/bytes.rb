require 'backports/tools'

Backports.alias_method String, :bytes, :each_byte
