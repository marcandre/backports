# ruby-rewrite -m -l lib/backports/random/rewriter.rb lib/backports/1.* lib/backports/2.* lib/backports/rails* lib/backports/random/implementation.rb

class Rewriter < ::Parser::Rewriter
  def track(range)
    name = range.source_buffer.name.split('/').last(3).join('/')
    insert_before(range, "Backports.introspect # Special 'introspection' edition; not for production use\n      ")
  end

  def on_def(node)
    body = node.children[2]
    track(body.loc.expression)
  end

  def on_defs(node)
    body = node.children[3]
    track(body.loc.expression)
  end

  # def on_send(node)
  #   receiver, method, arg, = node.children
  #   if receiver == nil && method == :require && arg.type == :str && arg.child[0] == 'backports'
  #     replace arg.loc.expression, 'backports_with_introspection'
  #   end
  # end
end
