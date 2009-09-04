class String
  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  alias_method :bytesize, :length unless method_defined? :bytesize

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def chr
    chars.first
  end unless method_defined? :chr

  Backports.make_block_optional self, :each_byte, :each_line, :test_on => "abc"

  Backports.make_block_optional self, :each, :test_on => "abc" if "is there still an each?".respond_to? :each

  # gsub: Left alone because of $~, $1, etc... which needs to be "pushed" up one level
  # It's possible to do so, but gsub is used everywhere so i felt
  # the performance hit was too big compared to the dubious gain.

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  unless method_defined? :each_char
    def each_char(&block)
      return to_enum(:each_char) unless block_given?
      scan(/./, &block)
    end

    alias_method :chars, :each_char unless method_defined? :chars
  end

  alias_method :lines, :each_line unless method_defined? :lines

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  def end_with?(*suffixes)
    suffixes.each do |suffix|
      next unless suffix.respond_to? :to_str
      suffix = suffix.to_str
      return true if self[-suffix.length, suffix.length] == suffix
    end
    false
  end unless method_defined? :end_with?

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  unless ("check partition".partition(" ") rescue false)
    def partition_with_new_meaning(pattern = Backports::Undefined, &block)
      return partition_without_new_meaning(&block) if pattern == Backports::Undefined
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
    prefixes.each do |prefix|
      next unless prefix.respond_to? :to_str
      prefix = prefix.to_str
      return true if self[0, prefix.length] == prefix
    end
    false
  end unless method_defined? :start_with?

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/String.html]
  unless ("abc".upto("def", true) rescue false)
    def upto_with_exclusive(to, excl=false, &block)
      return upto_without_exclusive(to, &block) if block_given? && !excl
      enum = Range.new(self, to, excl).to_enum
      return enum unless block_given?
      enum.each(&block)
      self
    end
    Backports.alias_method_chain self, :upto, :exclusive
  end
end
