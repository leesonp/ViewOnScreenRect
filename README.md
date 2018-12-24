# ViewOnScreenRect
自定义PopView，实现点击某个视图动态展示。
- 根据点击视图的origin.x动态计算popview出现的横向距离
- 根据点击视图的origin.y动态计算popview出现的纵向距离
- 用drawRect方法绘制popview的形状，封装圆弧倒角的绘制方法以及镜像圆弧倒角的绘制方法等
- 输入暴露的api方法，一行代码引入项目。
