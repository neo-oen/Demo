内边距和frame是不可以共存的，好多应用都有设置内边距，其做法就是自动布局，

布局的时候一定要考虑到内边距，这样内边距才有效。
如，inset.left + width + jianju + width2 + inset.right.=WIDTH;
