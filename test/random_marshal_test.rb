# Run independently and with Ruby 1.9

def get_randomizer
  r = Random.new(42)
  1000.times{r.rand}
  r
end

def get_info(r)
  Hash[
    [:state, :left, :seed].map{|info| [info, r.send(info)]}
  ]
end

MRIs = get_randomizer
dump = Marshal.dump(MRIs)
Object.send :remove_const, :Random # Kill original definition

require_relative "../lib/backports/1.9.2"

ours = get_randomizer

puts "Info ok" if get_info(MRIs) == get_info(ours)
if dump == (our_dump = Marshal.dump(get_randomizer))
  puts "dump identical" 
else
  puts "Oups"
end
if get_info(MRIs) == get_info(Marshal.load(dump))
  puts "load identical" 
else
  puts "Oups"
end
