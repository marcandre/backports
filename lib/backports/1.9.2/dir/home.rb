unless Dir.respond_to? :home
  def Dir.home(user = "")
    Backports.introspect # Special 'introspection' edition; not for production use
      File.expand_path "~#{user}"
  end
end
