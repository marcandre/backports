unless (File.dirname("", 0) rescue false)
  require 'backports/tools/alias_method_chain'

  class File
    def self.dirname_with_depth(path, depth = 1)
      return dirname_without_depth(path) if depth == 1

      raise ArgumentError, "negative depth #{depth}" if depth < 0

      depth.times { path = dirname_without_depth(path) }

      path
    end
    Backports.alias_method_chain singleton_class, :dirname, :depth
  end
end
