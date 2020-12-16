class SharedHash
  def initialize(initial = {})
    @ractor = Ractor.new(initial) do |hash|
      loop do
        case Ractor.receive
        in [:read, key, default, ractor] then
          ractor << hash.fetch(key, default)
        in [:write, key, value]  then
          hash[key] = value
        in [:inspect | :to_s | :to_h => cmd, ractor] then
           ractor << hash.send(cmd)
        else raise ArgumentError
        end
      end
    end
  end

  def [](key)
    @ractor << [:read, key, nil, Ractor.current]
    Ractor.receive
  end

  def []=(key, value)
    @ractor << [:write, key, value]
    value
  end

  def inspect
    @ractor << [:inspect, Ractor.current]
    Ractor.receive
  end
end
