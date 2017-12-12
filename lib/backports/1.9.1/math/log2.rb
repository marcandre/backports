unless Math.respond_to? :log2
  def Math.log2(numeric)
    Backports.introspect # Special 'introspection' edition; not for production use
      log(numeric) / log(2)
  end
end
