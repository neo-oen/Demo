


优化tableview的方法：
在cellForRowAtIndexPath这里面，直接赋值，不做任何运算。

由于init 和initwithXX是有序序关系的，骚后，调试查看下：可能会再走一下init


修改cell的model，增加cellweight，和cellmodel 里增加cell属性（弱关联）哪个更好呢


cell里初始化设置要分成，只需要设置一次的，和多少使用的


textfilt
textfilt 的clearbutton 与 reghtview 是不是可以一起显示待定
不可以，可以看成clearbutton 就是rightView的一种实现；
两个一齐写的话，clearbutton就不会出现。



单例模式先不写了，这里的NSNotificationCenter虽然是单例，但是，是已经实例换直接可用的不需要通过，另外一种模式获取地址，或者[NSNotificationCenter defaultCenter]就是他是获取地址的方法，



写了一个方法来判断NSDictionary里的数据类型
id jk = dic[@"sdfd"];
[jk class];



要提供很多，很多有用的方法，最好的就是让方法划一。


table说，我知道，我要总高度，你给不了我，你就的先把你的高度给我，我自己加（这个只用于添加的单个cellmodel时候用）

多个cell 也是一个cellmodel
