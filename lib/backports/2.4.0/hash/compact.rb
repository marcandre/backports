class Hash
  def compact
    Backports.introspect # Special 'introspection' edition; not for production use
      h = {}
    each do |key, value|
      h[key] = value unless value == nil
    end
    h
  end unless method_defined? :compact

  def compact!
    Backports.introspect # Special 'introspection' edition; not for production use
      reject! {|_key, value| value == nil}
  end unless method_defined? :compact!
end
