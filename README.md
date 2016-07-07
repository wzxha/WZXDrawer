# WZXDrawer
侧滑框架<br>
当前版本**0.2**

## Version
- Version 0.1
   - 基本的侧滑功能.
   - 自定义左右view长度.
- Version 0.2
   - 加入拖动手势.

## 当前效果
![image](https://github.com/Wzxhaha/WZXStorehouse/blob/master/WZXDrawer/WZXDrawer.gif)

## 怎么使用
- 基本的侧滑功能,先创建一个VC继承于WZXDrawerViewController

  ```objc
  /**
  *  左右抽屉
  *
  *  @param leftVC  左vc
  *  @param mainVC  中间vc
  *  @param rightVC 右vc
  *
  *  @return WZXDrawerViewController对象
  */
  + (WZXDrawerViewController *)wzx_drawerViewControllerWithLeftViewController:(UIViewController *)leftVC          mainViewController:(UIViewController *)mainVC 
  rightViewController:(UIViewController *)rightVC;
  ```

- 自定义左右view长度

  ```objc
  xxxVC.leftViewWidth = 300;
  xxxVC.rightViewWidth = 200;
  ```
  
- 滑动方法，需在子vc中import "WZXDrawerViewController.h"
 
  ```objc
  wzx_showLeft(BOOL animated);
  wzx_showRight(BOOL animated);
  wzx_dismiss(BOOL animated);
  ```
  
## TODO
- ~~拖动事件~~ 
- 阴影效果
- ~~更加优雅的滑动方法~~
