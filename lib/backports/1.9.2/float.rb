class Float
  INFINITY = 1.0/0.0 unless const_defined? :INFINITY
  NAN = 0.0/0.0 unless const_defined? :NAN
end