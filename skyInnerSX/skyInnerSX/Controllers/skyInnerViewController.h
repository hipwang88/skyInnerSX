//
//  skyInnerViewController.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skySettingMainVC.h"
#import "skyModelViewController.h"
#import "skySettingConnectionVC.h"
#import "skySettingConfigVC.h"
#import "skySettingSignalVC.h"
#import "skySettingUnitVC.h"

@interface skyInnerViewController : UIViewController

////////////////////////// Property /////////////////////////////
// 导航栏支持视图
@property (strong, nonatomic) UIPopoverController *settingsPopover;             // 系统设置弹出视图
@property (strong, nonatomic) UIPopoverController *modelsPopover;               // 情景模式弹出视图
@property (strong, nonatomic) UINavigationController *settingsNavgation;        // 系统设置弹出视图导航控制器
@property (strong, nonatomic) UINavigationController *modelsNavigation;         // 情景模式弹出视图导航控制器
@property (strong, nonatomic) UIPopoverController *currentPopover;              // 临时值：当前弹出视图 -- 用来隐藏弹出视图
@property (strong, nonatomic) skySettingMainVC *settingMainVC;                  // 设置主视图控制器
@property (strong, nonatomic) skyModelViewController *modelVC;                  // 情景模式主视图控制器

////////////////////////// Methods //////////////////////////////

////////////////////////// Ends /////////////////////////////////

@end
