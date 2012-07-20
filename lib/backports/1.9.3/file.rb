module File::Constants
  platform = RUBY_PLATFORM
  platform = RbConfig::CONFIG['host_os'] if platform == 'java'
  NULL =  case platform
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
