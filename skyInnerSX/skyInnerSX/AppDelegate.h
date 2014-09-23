//
//  AppDelegate.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyAppStatus.h"                        // 程序状态类
#import "skyInnerViewController.h"              // 程序主视图控制器

@interface AppDelegate : UIResponder <UIApplicationDelegate>

////////////////////// Property ///////////////////////////
@property (strong, nonatomic) UIWindow *window;
// 主视图导航
@property (strong, nonatomic) UINavigationController *navigator;
// 程序主视图控制器
@property (strong, nonatomic) skyInnerViewController *appViewController;
// 程序状态管理
@property (strong, nonatomic) skyAppStatus *theApp;

////////////////////// Methods ////////////////////////////

////////////////////// Ends ///////////////////////////////

@end

