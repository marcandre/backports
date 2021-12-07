class MatchData
  def match_length(index)
    m = self[index]
    m && m.length
  end
end unless MatchData.method_defined? :match_length
