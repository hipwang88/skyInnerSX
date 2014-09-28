//
//  skySettingUnitVC.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyPopBaseViewController.h"
#import "skyUnitSelectionVC.h"

// Delegate Protocol
@protocol skySettingUnitVCDelegate <NSObject>

// 显示编号
- (void)showPanelNum;
// 隐藏编号
- (void)hidePanelNum;
// 屏幕开机
- (void)unitOn;
// 屏幕关机
- (void)unitOff;
// 白平衡自动调整
- (void)addjustWB;
// 位置自动调整
- (void)addjusetPosition;
// 对比度增加
- (void)contrastIncrease;
// 对比度减少
- (void)contrastDecrease;
// 对比度复位
- (void)contrastRest;
// 亮度增加
- (void)brightnessIncrease;
// 亮度减少
- (void)brightnessDecrease;
// 亮度复位
- (void)brightnessRest;
// 菜单按钮
- (void)sendMenuClick;
// 上按钮
- (void)sendUpClick;
// 下按钮
- (void)sendDownClick;
// 左按钮
- (void)sendLeftClick;
// 右按钮
- (void)sendRightClick;
// 屏显按钮
- (void)sendPanelDisplayClick;
// 信号按钮
- (void)sendSignalClick;
// 确认按钮
- (void)sendConfirmClick;
// 退出按钮
- (void)sendQuitClick;

@end

// class skySettingUnitVC
@interface skySettingUnitVC : skyPopBaseViewController<UITableViewDelegate,UITableViewDataSource>

//////////////////////// Property /////////////////////////////
@property (strong, nonatomic) IBOutlet UITableView *myTableView;                // Table View对象
@property (strong, nonatomic) UISwitch *useKeyboardSwitch;                      // 虚拟键盘使用开关
@property (strong, nonatomic) id<skySettingUnitVCDelegate> myDelegate;          // 代理对象
@property (strong, nonatomic) skyUnitSelectionVC *selectionView;                // 单元选择视图

//////////////////////// Methods //////////////////////////////

//////////////////////// Ends /////////////////////////////////

@end
