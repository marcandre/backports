class File
  NULL =  case RUBY_PLATFORM
          when /mswin|mingw/i
            'NUL'
          when /amiga/i
            'NIL:'
          when /openvms/i
            'NL:'
          else
            '/dev/null'
          end unless const_defined?(:NULL)
end