class File
  def size
    stat.size
  end unless method_defined? :size

  Backports.alias_method self, :to_path, :path

  class << self
    if RUBY_VERSION < '1.9' # can't see any other reasonable way to test than this
      Backports.convert_all_arguments_to_path self, 0, :delete, :unlink, :join
      Backports.convert_all_arguments_to_path self, 1, :chmod, :lchmod
      Backports.convert_all_arguments_to_path self, 2, :chown, :lchown

      Backports.convert_first_argument_to_path self, :atime, :basename,
        :blockdev?, :chardev?, :ctime, :directory?, :dirname, :executable?, :executable_real?,
        :exist?, :exists?, :expand_path, :extname, :file?, :ftype, :grpowned?,
        :link, :lstat, :mtime, :new, :open, :owned?, :pipe?, :readable?, :readable_real?,
        :readlink, :rename, :setgid?, :setuid?, :size, :size?, :socket?,
        :split, :stat, :sticky?, :symlink, :symlink?, :truncate, :writable?,
        :writable_real?, :zero?
    end

    begin
      File.open(__FILE__, :mode => 'r').close
    rescue StandardError
      def open_with_options_hash(file, mode = nil, perm = nil, options = {}, &block)
        perm, options = nil, perm if Hash === perm
        mode, options = nil, mode if Hash === mode
        open_without_options_hash(file, mode || options[:mode], perm || options[:perm], &block)
      end

      Backports.alias_method_chain self, :open, :options_hash
    end
  end
end