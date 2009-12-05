class IO
  class << self
    def binread(file, *arg)
      raise ArgumentError, "wrong number of arguments (#{1+arg.size} for 1..3)" unless arg.size < 3
      File.open(Backports.convert_to_path(file),"rb") do |f|
        f.read(*arg)
      end
    end unless method_defined? :binread
  end
end