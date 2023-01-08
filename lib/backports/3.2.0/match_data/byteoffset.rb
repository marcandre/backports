unless MatchData.method_defined? :byteoffset
  class MatchData
    def byteoffset(n)
      if (char_start_offset = self.begin(n))
        char_end_offset = self.end(n)
        [string[0, char_start_offset].bytesize, string[0, char_end_offset].bytesize]
      else
        [nil, nil]
      end
    end
  end
end
