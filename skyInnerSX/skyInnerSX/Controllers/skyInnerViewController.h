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
#import "skyISXWin.h"
#import "skyUnderPaint.h"
#import "skyInner6M48TVSDK.h"

// class skyInnerViewController
// delegate:
//          skySettingConnectionVCDelegate  --- 通信连接代理
//          skySettingConfigVCDelegate      --- 规格设置代理
//          skySettingUnitVCDelegate        --- 屏幕控制设置代理
//          skyUnitSelectionVCDelegate      --- 屏幕单元选择代理
//          skyISXWinDelegate               --- 拼接窗口代理
//          skyModelViewControllerDelegate  --- 情景模式代理
//
@interface skyInnerViewController : UIViewController<skySettingConnectionVCDelegate,skySettingConfigVCDelegate,skySettingUnitVCDelegate,skyUnitSelectionVCDelegate,skyISXWinDelegate,skyModelViewControllerDelegate>
{
    skyISXWin   *currentISXWin;         // 当前控制窗口
}

////////////////////////// Property /////////////////////////////
// 导航栏支持视图
@property (strong, nonatomic) UIPopoverController *settingsPopover;             // 系统设置弹出视图
@property (strong, nonatomic) UIPopoverController *modelsPopover;               // 情景模式弹出视图
@property (strong, nonatomic) UINavigationController *settingsNavgation;        // 系统设置弹出视图导航控制器
@property (strong, nonatomic) UINavigationController *modelsNavigation;         // 情景模式弹出视图导航控制器
@property (strong, nonatomic) UIPopoverController *currentPopover;              // 临时值：当前弹出视图 -- 用来隐藏弹出视图
@property (strong, nonatomic) skySettingMainVC *settingMainVC;                  // 设置主视图控制器
@property (strong, nonatomic) skyModelViewController *modelVC;                  // 情景模式主视图控制器

// 拼接客户区底图
@property (strong, nonatomic) skyUnderPaint *underPaint;
// 拼接单元组
@property (strong, nonatomic) NSMutableArray *isxWinContainer;
// 控制协议
@property (strong, nonatomic) skyInner6M48TVSDK *spliceTVProtocol;

////////////////////////// Methods //////////////////////////////

////////////////////////// Ends /////////////////////////////////

@end
