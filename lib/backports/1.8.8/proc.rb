class Proc
  alias_method :===, :call unless Proc.new{true} === 42
end