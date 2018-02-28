做的是啥：
1，测试，使用view里的transform来改变view来实现图形改变。成功
2，制作，滑动progress，形变view和，view里的图形。
3,测试, 各种绘图.
4,测试,各种手势

有啥功能：


线宽是左右个加一半，所以可能超出范围
drawAtPoint 比较屌，他可判断自己怎么样填写


setTranslation是干啥用的

为啥他们都重置了呢, rotationGesture.rotation = 0;

都是一个原因,点动的时候,给出的值是不断,而且很多,如果不重置的话,就被加上
