//
//  MainViewController.m
//  WZXDrawer
//
//  Created by WzxJiang on 16/6/14.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "MainViewController.h"
#import "WZXDrawerViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    NSArray * titles = @[@"左",@"右"];
    NSArray * sels = @[@"showLeft:",@"showRight:"];
    
    for (int i = 0; i < titles.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.bounds = CGRectMake(0, 0, 100, 50);
        btn.center = CGPointMake(self.view.center.x, self.view.center.y - 25 + i*50);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:NSSelectorFromString(sels[i]) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)showLeft:(UIButton *)sender {
    wzx_showLeft(YES);
}

- (void)showRight:(UIButton *)sender {
    wzx_showRight(YES);
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
