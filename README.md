# WZXDrawer
侧滑框架
当前版本0.1

## Version 0.1 功能
- 基本的侧滑功能
- 自定义左右view长度

## 怎么使用
- 基本的侧滑功能,先import "WZXDrawerViewController.h"

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
  
## 将要完成的功能
- 拖动事件
- 阴影效果
- 更加优雅的滑动方法
