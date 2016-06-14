//
//  WZXDrawerViewController.h
//  WZXDrawer
//
//  Created by WzxJiang on 16/6/13.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * WZX_DRAWER_SHOW_LEFT;
extern NSString * WZX_DRAWER_SHOW_RIGHT;
extern NSString * WZX_DRAWER_DISMISS;

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunused-function"
static void wzx_showLeft(BOOL animated) {
    [[NSNotificationCenter defaultCenter]postNotificationName:WZX_DRAWER_SHOW_LEFT object:nil userInfo:@{@"animated":@(animated)}];
};

static void wzx_showRight(BOOL animated) {
    [[NSNotificationCenter defaultCenter]postNotificationName:WZX_DRAWER_SHOW_RIGHT object:nil userInfo:@{@"animated":@(animated)}];
};

static void wzx_dismiss(BOOL animated) {
    [[NSNotificationCenter defaultCenter]postNotificationName:WZX_DRAWER_DISMISS object:nil userInfo:@{@"animated":@(animated)}];
};
#pragma clang diagnostic pop

@interface WZXDrawerViewController : UIViewController

typedef NS_ENUM(NSInteger,WZXDrawerType) {
    /** 默认,平行 */
    WZXDrawerTypePlane,
};

@property(nonatomic,strong)UIViewController * leftVC;
@property(nonatomic,strong)UIViewController * mainVC;
@property(nonatomic,strong)UIViewController * rightVC;

/**
 *  默认WZXDrawerTypePlane
 */
@property(nonatomic,assign)WZXDrawerType drawerType;

/**
 *  默认300
 */
@property(nonatomic,assign)CGFloat leftViewWidth;

/**
 *  默认300
 */
@property(nonatomic,assign)CGFloat rightViewWidth;

/**
 *  默认YES
 */
@property(nonatomic,assign)BOOL canPan;

/**
 *  动画时间,默认0.5s
 */
@property(nonatomic,assign)CGFloat duration;
/**
 *  左右抽屉
 *
 *  @param leftVC  左vc
 *  @param mainVC  中间vc
 *  @param rightVC 右vc
 *
 *  @return WZXDrawerViewController对象
 */
+ (instancetype)wzx_drawerViewControllerWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC;
/**
 *  左抽屉
 *
 *  @param leftVC 左vc
 *  @param mainVC 中间vc
 *
 *  @return WZXDrawerViewController对象
 */
+ (WZXDrawerViewController *)wzx_drawerViewControllerWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC;

/**
 *  右抽屉
 *
 *  @param mainVC  中间vc
 *  @param rightVC 右vc
 *
 *  @return WZXDrawerViewController对象
 */
+ (WZXDrawerViewController *)wzx_drawerViewControllerWithMainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC;

- (instancetype)initWithLeftViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC rightViewController:(UIViewController *)rightVC;




@end
