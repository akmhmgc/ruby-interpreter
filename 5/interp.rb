require 'minruby'

def evaluate(tree, lenv = {}, genv={ "p" => ["builtin", "p"]})
  case tree[0]
  when 'lit'
    tree[1]
  when 'func_call'
    args = tree[2..-1].map { |arg| evaluate(arg, lenv, genv) }
    mhd = genv[tree[1]]
    case mhd[0]
    when 'builtin'
      send(mhd[1], *args)
    when 'user_defined'
      new_lenv = {}
      mhd[1].each do |var|
        new_lenv[var] = args.shift
      end
      evaluate(mhd[2], new_lenv, genv)
    end
  when 'func_def'
    genv[tree[1]] = ["user_defined", tree[2], tree[3]]
  when 'stmts'
    last = nil
    tree[1..-1].each do |statement|
      last = evaluate(statement, lenv, genv)
      last
    end
    last
  when 'var_assign'
    lenv[tree[1]] = evaluate(tree[2], lenv, genv)
  when 'var_ref'
    lenv[tree[1]]
  when 'ary_new'
    ary = []
    tree[1..-1].each {|element| ary << evaluate(element, lenv, genv)}
    ary
  when 'ary_ref'
    ary = evaluate(tree[1], lenv, genv)
    idx = evaluate(tree[2], lenv, genv)
    ary[idx]
  when 'ary_assign'
    ary = evaluate(tree[1], lenv, genv)
    idx = evaluate(tree[2], lenv, genv)
    val = evaluate(tree[3], lenv, genv)
    ary[idx] = val
  when 'hash_new'
    hash = {}
    ((tree.size - 1)/2).times do |i|
      key = evaluate(tree[i + 1], lenv, genv)
      val = evaluate(tree[i + 2], lenv, genv)
      hash[key] = val
    end
    hash
  when 'if'
    # インタプリタの本質は、ターゲット言語の言語機能を、ホス言語の機能に丸投げすること
    evaluate(tree[1], lenv, genv) ? evaluate(tree[2], lenv, genv) : evaluate(tree[3], lenv, genv)
  when 'while'
    while evaluate(tree[1], lenv, genv)
      evaluate(tree[2], lenv, genv)
    end
  else
    left = evaluate(tree[1], lenv, genv)
    right = evaluate(tree[2], lenv, genv)
    operator = tree[0]
    eval("#{left} #{operator} #{right}")
  end
end

str = minruby_load
tree = minruby_parse(str)
evaluate(tree)
