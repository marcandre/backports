class String
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  Backports.alias_method self, :bytesize, :length

  Backports.make_block_optional self, :each_byte, :each_line, :test_on => "abc"

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  Backports.alias_method self, :bytes, :each_byte

  Backports.make_block_optional self, :each, :test_on => "abc" if "is there still an each?".respond_to? :each

  # gsub: Left alone because of $~, $1, etc... which needs to be "pushed" up one level
  # It's possible to do so, but gsub is used everywhere so i felt
  # the performance hit was too big compared to the dubious gain.

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  unless method_defined? :each_char
    def each_char
      return to_enum(:each_char) unless block_given?
      scan(/./m) {|c| yield c}
    end

    Backports.alias_method self, :chars, :each_char
  end

  Backports.alias_method self, :lines, :each_line

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def end_with?(*suffixes)
    suffixes.any? do |suffix|
      if suffix.respond_to? :to_str
        suffix = suffix.to_str
        self[-suffix.length, suffix.length] == suffix
      end
    end
  end unless method_defined? :end_with?

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  unless ("check partition".partition(" ") rescue false)
    def partition_with_new_meaning(pattern = Backports::Undefined)
      return partition_without_new_meaning{|c| yield c} if pattern == Backports::Undefined
      pattern = Backports.coerce_to(pattern, String, :to_str) unless pattern.is_a? Regexp
      i = index(pattern)
      return [self, "", ""] unless i
      if pattern.is_a? Regexp
        match = Regexp.last_match
        [match.pre_match, match[0], match.post_match]
      else
        last = i+pattern.length
        [self[0...i], self[i...last], self[last...length]]
      end
    end
    Backports.alias_method_chain self, :partition, :new_meaning
  end

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def rpartition(pattern)
    pattern = Backports.coerce_to(pattern, String, :to_str) unless pattern.is_a? Regexp
    i = rindex(pattern)
    return ["", "", self] unless i

    if pattern.is_a? Regexp
      match = Regexp.last_match
      [match.pre_match, match[0], match.post_match]
    else
      last = i+pattern.length
      [self[0...i], self[i...last], self[last...length]]
    end
  end unless method_defined? :rpartition

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def start_with?(*prefixes)
    prefixes.any? do |prefix|
      if prefix.respond_to? :to_str
        prefix = prefix.to_str
        self[0, prefix.length] == prefix
      end
    end
  end unless method_defined? :start_with?

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  unless ("abc".upto("def", true) rescue false)
    def upto_with_exclusive(to, excl=false)
      return upto_without_exclusive(to){|s| yield s} if block_given? && !excl
      enum = Range.new(self, to, excl).to_enum
      return enum unless block_given?
      enum.each{|s| yield s}
      self
    end
    Backports.alias_method_chain self, :upto, :exclusive
  end
end
