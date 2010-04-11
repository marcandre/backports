class << Dir
  def home(user = "")
    File.expand_path "~#{user}"
  end unless method_defined? :home
end