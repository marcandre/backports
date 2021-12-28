class Integer
  require 'backports/tools/arguments'

  def self.try_convert(obj)
    ::Backports.try_convert(obj, ::Integer, :to_int)
  end
end unless Integer.respond_to? :try_convert
