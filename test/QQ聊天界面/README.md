


优化tableview的方法：
在cellForRowAtIndexPath这里面，直接赋值，不做任何运算。

由于init 和initwithXX是有序序关系的，骚后，调试查看下：可能会再走一下init


修改cell的model，增加cellweight，和cellmodel 里增加cell属性（弱关联）哪个更好呢


修改tableviewcell里的model的set方法，
 tablesectionview 里面需要修改来支持更新hidden

拉伸的xcode图形化操作

我要给textfilt 增加一个扩展，addleftviewwithmode   addrightviewwithmode

clearbutton 与reghtview 


通知机制


单例模式先不写了，这里的NSNotificationCenter虽然是单例，但是，是已经实例换直接可用的不需要通过，另外一种模式获取地址，或者[NSNotificationCenter defaultCenter]就是他是获取地址的方法，


懒加载怎么玩


time还没写，还有隐藏也没有写，剩下就是自动回复。



写了一个方法来判断NSDictionary里的数据类型
