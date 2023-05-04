require 'minruby'

tree = minruby_parse('1 + 2 * 4 + 9')

def evaluate(tree)
  return tree[1] if tree[0] == 'lit'

  left = evaluate(tree[1])
  right = evaluate(tree[2])
  operator = tree[0]
  eval("#{left} #{operator} #{right}")
end

p evaluate(tree)
