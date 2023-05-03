tree = ['節 1', ['節 2', ['葉 A'], ['葉 B']], ['節 3', ['葉 C'], ['葉 D']]]

def preorder(tree)
  p tree[0]
  return unless tree[0].start_with?('節')

  preorder(tree[1])
  preorder(tree[2])
end

def inorder(tree)
  if tree[0].start_with?('節')
    inorder(tree[1])
    inorder(tree[2])
  end

  p tree[0]
end

inorder(tree)
