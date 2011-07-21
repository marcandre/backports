Backports::Stdlib.require 'date'

class Date
  def to_time
    Time.local year, mon, mday
  end unless method_defined? :to_time
end

class DateTime
  def to_time
    d = new_offset 0
    t = Time.utc d.year, d.mon, d.mday, d.hour, d.min, d.sec + d.sec_fraction
    t.getlocal
  end unless method_defined? :to_time
end

class Time
  Backports.alias_method self, :to_time, :getlocal
end

