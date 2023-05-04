require 'minruby'

def evaluate(tree)
  case tree[0]
  when 'lit'
    tree[1]
  when 'func_call'
    p evaluate(tree[2])
  when 'stmts'
    last = nil
    tree[1..-1].each do |statement|
      last = evaluate(statement)
      last
    end
    last
  else
    left = evaluate(tree[1])
    right = evaluate(tree[2])
    operator = tree[0]
    eval("#{left} #{operator} #{right}")
  end
end

str = minruby_load
tree = minruby_parse(str)
evaluate(tree)
