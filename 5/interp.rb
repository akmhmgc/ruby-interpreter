require 'minruby'

def evaluate(tree)
  return tree[1] if tree[0] == 'lit'

  p evaluate(tree[2]) and return if tree[0] == 'func_call'

  left = evaluate(tree[1])
  right = evaluate(tree[2])
  operator = tree[0]
  eval("#{left} #{operator} #{right}")
end

str = minruby_load
tree = minruby_parse(str)
answer = evaluate(tree)
