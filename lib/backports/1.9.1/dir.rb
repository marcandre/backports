class Dir
  alias_method :to_path, :path unless method_defined? :to_path
end