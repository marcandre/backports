class MatchData
  def match(index)
    self[index]
  end
end unless MatchData.method_defined? :match
