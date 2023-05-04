require 'minruby'

def evaluate(tree, env = {})
  case tree[0]
  when 'lit'
    tree[1]
  when 'func_call'
    p evaluate(tree[2], env)
  when 'stmts'
    last = nil
    tree[1..-1].each do |statement|
      last = evaluate(statement, env)
      last
    end
    last
  when 'var_assign'
    env[tree[1]] = evaluate(tree[2], env)
  when 'var_ref'
    env[tree[1]]
  else
    left = evaluate(tree[1], env)
    right = evaluate(tree[2], env)
    operator = tree[0]
    eval("#{left} #{operator} #{right}")
  end
end

str = minruby_load
tree = minruby_parse(str)
evaluate(tree)
