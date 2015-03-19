# XBLockView

##类似支付宝九宫格锁屏解锁功能
可以设置横向与竖向的个数，自动计算个数做UI自适应



`Code Example:`

1. 实现delegate：XBLockViewDelegate

- (void)XBLockViewLockPassword:(NSString *)password
{
    NSLog(@"%@",password);
}

2.创建View

  XBLockView* lock = [[XBLockView alloc] initWithSize:self.view.bounds hor:3 ver:3];
  
  lock.delegate = self;
  
  [self.view addSubview:lock];

`ScreenShot:`

![](https://raw.githubusercontent.com/JxbSir/XBLockView/master/screenshoot/screenshot.gif)
