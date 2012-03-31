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
      def open_with_options_hash(file, mode = nil, perm = Backports::Undefined, options = Backports::Undefined)
        mode, perm = Backports.combine_mode_perm_and_option(mode, perm, options)
        perm ||= 0666 # Avoid error on Rubinius, see issue #52
        if block_given?
          open_without_options_hash(file, mode, perm){|f| yield f}
        else
          open_without_options_hash(file, mode, perm)
        end
      end

      Backports.alias_method_chain self, :open, :options_hash
    end
  end

  module Constants
    # In Ruby 1.8, it is defined only on Windows
    BINARY = 0 unless const_defined?(:BINARY)
  end
end