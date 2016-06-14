//
//  WZXDrawerViewController.m
//  WZXDrawer
//
//  Created by WzxJiang on 16/6/13.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "WZXDrawerViewController.h"

NSString * WZX_DRAWER_SHOW_LEFT  = @"WZX_DRAWER_SHOW_LEFT";
NSString * WZX_DRAWER_SHOW_RIGHT = @"WZX_DRAWER_SHOW_RIGHT";
NSString * WZX_DRAWER_DISMISS    = @"WZX_DRAWER_DISMISS";

typedef NS_ENUM(NSInteger, WZXDrawerShowState) {
    WZXDrawerShowStateNone  = 0,
    WZXDrawerShowStateLeft  = 1,
    WZXDrawerShowStateRight = 2,
};

@interface WZXDrawerViewController ()

@end

@implementation WZXDrawerViewController {
    WZXDrawerShowState _showState;
    UIPanGestureRecognizer *_leftVCPanGestureRecognizer;
    UIPanGestureRecognizer *_rightVCPanGestureRecognizer;
}

+ (WZXDrawerViewController *)wzx_drawerViewControllerWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC {
    WZXDrawerViewController * drawerVC = [[WZXDrawerViewController alloc]initWithLeftViewController:leftVC mainViewController:mainVC rightViewController:rightVC];
    return drawerVC;
}

+ (WZXDrawerViewController *)wzx_drawerViewControllerWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC {
    return [WZXDrawerViewController wzx_drawerViewControllerWithLeftViewController:leftVC mainViewController:mainVC rightViewController:nil];
}

+ (WZXDrawerViewController *)wzx_drawerViewControllerWithMainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC {
    return [WZXDrawerViewController wzx_drawerViewControllerWithLeftViewController:nil mainViewController:mainVC rightViewController:rightVC];
}

- (instancetype)initWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC {
    if (self = [super init]) {
        _leftVC  = leftVC;
        _mainVC  = mainVC;
        _rightVC = rightVC;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _drawerType     = WZXDrawerTypePlane;
    _leftViewWidth  = 300;
    _rightViewWidth = 300;
    
    _canPan         = YES;
    _duration       = 0.5;
    
    if (self.leftVC)  {
        [self addLeftViewController];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wzx_showLeft:) name:WZX_DRAWER_SHOW_LEFT object:nil];
    }
    if (self.rightVC) {
        [self addRightViewController];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wzx_showRight:) name:WZX_DRAWER_SHOW_RIGHT object:nil];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wzx_dismiss:) name:WZX_DRAWER_DISMISS object:nil];
    
    [self addMainViewController];
}

#pragma mark -- add

- (void)addMainViewController {
    [self addChildViewController:_mainVC];
    _mainVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_mainVC.view];
    [_mainVC didMoveToParentViewController:self];
}

- (void)addLeftViewController {
    [self addChildViewController:_leftVC];
    
    if (_drawerType == WZXDrawerTypePlane) {
        _leftVC.view.frame = CGRectMake(-_leftViewWidth, 0, _leftViewWidth, self.view.frame.size.height);
    } else {
        
    }
    
    [self.view addSubview:_leftVC.view];
    [_leftVC didMoveToParentViewController:self];
}

- (void)addRightViewController {
    [self addChildViewController:_rightVC];
    
    if (_drawerType == WZXDrawerTypePlane) {
        _rightVC.view.frame = CGRectMake(self.view.frame.size.width, 0, _rightViewWidth, self.view.frame.size.height);
    } else {
        
    }

    [self.view addSubview:_rightVC.view];
    [_rightVC didMoveToParentViewController:self];
}

#pragma mark -- show & dismiss

- (void)_showLeftViewController:(BOOL)animated {
    if (_drawerType == WZXDrawerTypePlane) {
        [UIView animateWithDuration:animated?_duration:0 animations:^{
            CGRect leftFrame    = _leftVC.view.frame;
            leftFrame.origin.x  = 0;
            _leftVC.view.frame  = leftFrame;
            
            CGRect mainFrame    = _mainVC.view.frame;
            mainFrame.origin.x += _leftViewWidth;
            _mainVC.view.frame  = mainFrame;
        }];
    }
}

- (void)_showRightViewController:(BOOL)animated {
    if (_drawerType == WZXDrawerTypePlane) {
        [UIView animateWithDuration:animated?_duration:0 animations:^{
            CGRect rightFrame    = _rightVC.view.frame;
            rightFrame.origin.x -= _rightViewWidth;
            _rightVC.view.frame  = rightFrame;
            
            CGRect mainFrame     = _mainVC.view.frame;
            mainFrame.origin.x  -= _rightViewWidth;
            _mainVC.view.frame   = mainFrame;
        }];
    }
}

- (void)_hideLeftViewController:(BOOL)animated {
    if (_drawerType == WZXDrawerTypePlane) {
        [UIView animateWithDuration:animated?_duration:0 animations:^{
            CGRect leftFrame    = _leftVC.view.frame;
            leftFrame.origin.x -= _leftViewWidth;
            _leftVC.view.frame  = leftFrame;
            
            CGRect mainFrame    = _mainVC.view.frame;
            mainFrame.origin.x  = 0;
            _mainVC.view.frame  = mainFrame;
        }];
    }
}

- (void)_hideRightViewControlelr:(BOOL)animated {
    if (_drawerType == WZXDrawerTypePlane) {
        [UIView animateWithDuration:animated?_duration:0 animations:^{
            CGRect rightFrame    = _rightVC.view.frame;
            rightFrame.origin.x  = self.view.frame.size.width;
            _rightVC.view.frame  = rightFrame;
            
            CGRect mainFrame     = _mainVC.view.frame;
            mainFrame.origin.x   = 0;
            _mainVC.view.frame   = mainFrame;
        }];
    }
}

- (void)wzx_showLeft:(NSNotification *)noti {
    if (!_leftVC) {
        return;
    }
    
    BOOL animated = noti.userInfo[@"animated"];
    
    if (_showState == WZXDrawerShowStateLeft) {
        return;
    } else if (_showState == WZXDrawerShowStateRight) {
        [self _hideRightViewControlelr:animated];
    }
    
    [self _showLeftViewController:animated];
    _showState = WZXDrawerShowStateLeft;
    
}

- (void)wzx_showRight:(NSNotification *)noti {
    if (!_rightVC) {
        return;
    }
    BOOL animated = noti.userInfo[@"animated"];
    
    if (_showState == WZXDrawerShowStateRight) {
        return;
    } else if (_showState == WZXDrawerShowStateLeft) {
        [self _hideLeftViewController:animated];
    }
    
    [self _showRightViewController:animated];
    _showState = WZXDrawerShowStateRight;
}

- (void)wzx_dismiss:(NSNotification *)noti {
    BOOL animated = noti.userInfo[@"animated"];
    
    if (_showState == WZXDrawerShowStateLeft) {
        [self _hideLeftViewController:animated];
    } else if (_showState == WZXDrawerShowStateRight) {
        [self _hideRightViewControlelr:animated];
    } else {
        return;
    }
    
    _showState = WZXDrawerShowStateNone;
}

#pragma mark set get
- (void)setLeftViewWidth:(CGFloat)leftViewWidth {
    _leftViewWidth = leftViewWidth;
    _leftVC.view.frame = CGRectMake(-_leftViewWidth, 0, _leftViewWidth, self.view.frame.size.height);
}

- (void)setRightViewWidth:(CGFloat)rightViewWidth {
    _rightViewWidth = rightViewWidth;
    _rightVC.view.frame = CGRectMake(self.view.frame.size.width, 0, _rightViewWidth, self.view.frame.size.height);
}



- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
