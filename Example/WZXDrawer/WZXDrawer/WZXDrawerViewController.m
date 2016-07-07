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
        [self leftViewControllerAddPan];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wzx_showLeft:) name:WZX_DRAWER_SHOW_LEFT object:nil];
    }
    if (self.rightVC) {
        [self addRightViewController];
        [self rightViewControllerAddPan];
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
    
    [self mainViewControllerAddPan];
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
        CGFloat realDuration = _duration * ABS(_leftVC.view.frame.origin.x / -_leftViewWidth);
        [UIView animateWithDuration:animated?realDuration:0 animations:^{
            CGRect leftFrame    = _leftVC.view.frame;
            leftFrame.origin.x  = 0;
            _leftVC.view.frame  = leftFrame;
            
            CGRect mainFrame    = _mainVC.view.frame;
            mainFrame.origin.x  = _leftViewWidth;
            _mainVC.view.frame  = mainFrame;
            
            CGRect rightFrame   = _rightVC.view.frame;
            mainFrame.origin.x  = self.view.frame.size.width + _leftViewWidth;
            _rightVC.view.frame = rightFrame;
        }];
    }
    _showState = WZXDrawerShowStateLeft;
}

- (void)_showRightViewController:(BOOL)animated {
    if (_drawerType == WZXDrawerTypePlane) {
        CGFloat realDuration = _duration * ABS((_rightViewWidth - self.view.frame.size.width + _rightVC.view.frame.origin.x) / _rightViewWidth);
        [UIView animateWithDuration:animated?realDuration:0 animations:^{
            CGRect rightFrame    = _rightVC.view.frame;
            rightFrame.origin.x  = self.view.frame.size.width - _rightViewWidth;
            _rightVC.view.frame  = rightFrame;
            
            CGRect mainFrame     = _mainVC.view.frame;
            mainFrame.origin.x   = -_rightViewWidth;
            _mainVC.view.frame   = mainFrame;
            
            CGRect leftFrame    = _leftVC.view.frame;
            leftFrame.origin.x  = -_leftViewWidth - _rightViewWidth;
            _leftVC.view.frame  = leftFrame;
        }];
    }
    _showState = WZXDrawerShowStateRight;
}

- (void)_hideViewController:(BOOL)animated {
    if (_drawerType == WZXDrawerTypePlane) {
        CGFloat realDuration = _duration * ABS((_leftViewWidth + _leftVC.view.frame.origin.x) / _leftViewWidth);
        [UIView animateWithDuration:animated?realDuration:0 animations:^{
            CGRect leftFrame    = _leftVC.view.frame;
            leftFrame.origin.x  = -_leftViewWidth;
            _leftVC.view.frame  = leftFrame;
            
            CGRect mainFrame    = _mainVC.view.frame;
            mainFrame.origin.x  = 0;
            _mainVC.view.frame  = mainFrame;
            
            CGRect rightFrame    = _rightVC.view.frame;
            rightFrame.origin.x  = self.view.frame.size.width;
            _rightVC.view.frame  = rightFrame;
        }];
    }
    _showState = WZXDrawerShowStateNone;
}

- (void)wzx_showLeft:(NSNotification *)noti {
    if (!_leftVC) {
        return;
    }
    
    BOOL animated = noti.userInfo[@"animated"];
    
    if (_showState == WZXDrawerShowStateLeft) {
        return;
    } else if (_showState == WZXDrawerShowStateRight) {
        [self _hideViewController:animated];
    }
    
    [self _showLeftViewController:animated];
}

- (void)wzx_showRight:(NSNotification *)noti {
    if (!_rightVC) {
        return;
    }
    BOOL animated = noti.userInfo[@"animated"];
    
    if (_showState == WZXDrawerShowStateRight) {
        return;
    } else if (_showState == WZXDrawerShowStateLeft) {
        [self _hideViewController:animated];
    }
    
    [self _showRightViewController:animated];
}

- (void)wzx_dismiss:(NSNotification *)noti {
    BOOL animated = noti.userInfo[@"animated"];
    
    if (_showState == WZXDrawerShowStateLeft ||
        _showState == WZXDrawerShowStateRight) {
        [self _hideViewController:animated];
    }  else {
        return;
    }
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

#pragma mark - addPan
- (void)leftViewControllerAddPan {
    [_leftVC.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(leftPanAction:)]];
}

- (void)rightViewControllerAddPan {
    [_rightVC.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(rightPanAction:)]];
}

- (void)mainViewControllerAddPan {
    [_mainVC.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(mainPanAction:)]];
}

#pragma mark - PanAction
- (void)leftPanAction:(UIPanGestureRecognizer *)sender {
    CGPoint pt = [sender translationInView:sender.view];
    CGRect leftViewFrame = _leftVC.view.frame;
    leftViewFrame.origin.x += pt.x;
    if (leftViewFrame.origin.x <= 0 &&
        leftViewFrame.origin.x >= -_leftViewWidth) {
        
        _leftVC.view.frame = leftViewFrame;
        [self changeOriginX:_mainVC.view addX:pt.x];
        [self changeOriginX:_rightVC.view addX:pt.x];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (leftViewFrame.origin.x > -_leftViewWidth/2.0) {
            [self _showLeftViewController:YES];
        } else {
            [self _hideViewController:YES];
        }
    }
    
    [sender setTranslation:CGPointZero inView:sender.view];
}

- (void)rightPanAction:(UIPanGestureRecognizer *)sender {
    CGPoint pt = [sender translationInView:sender.view];
    CGRect rightViewFrame = _rightVC.view.frame;
    rightViewFrame.origin.x += pt.x;
    if (rightViewFrame.origin.x <= self.view.frame.size.width
        && rightViewFrame.origin.x >= self.view.frame.size.width - _rightViewWidth) {
        _rightVC.view.frame = rightViewFrame;
        [self changeOriginX:_mainVC.view addX:pt.x];
        [self changeOriginX:_leftVC.view addX:pt.x];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (rightViewFrame.origin.x < (self.view.frame.size.width - _rightViewWidth/2.0)) {
            [self _showRightViewController:YES];
        } else {
            [self _hideViewController:YES];
        }
    }
    
    [sender setTranslation:CGPointZero inView:sender.view];
}

- (void)mainPanAction:(UIPanGestureRecognizer *)sender {
    CGPoint pt = [sender translationInView:sender.view];
    CGRect mainViewFrame = _mainVC.view.frame;
    mainViewFrame.origin.x += pt.x;
    if (mainViewFrame.origin.x <= _leftViewWidth &&
        mainViewFrame.origin.x >= -_rightViewWidth) {
        
        _mainVC.view.frame = mainViewFrame;
        [self changeOriginX:_leftVC.view addX:pt.x];
        [self changeOriginX:_rightVC.view addX:pt.x];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (_mainVC.view.frame.origin.x > _leftViewWidth/2.0){
            [self _showLeftViewController:YES];
        } else if (_mainVC.view.frame.origin.x < -_rightViewWidth/2.0) {
            [self _showRightViewController:YES];
        } else {
            [self _hideViewController:YES];
        }
    }
    
    [sender setTranslation:CGPointZero inView:sender.view];
}


- (void)changeOriginX:(UIView *)changeView addX:(CGFloat)addX {
    CGRect rect      = changeView.frame;
    rect.origin.x   += addX;
    changeView.frame = rect;
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
