//
//  skyHDMIMatrixSetting.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-24.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyPopBaseViewController.h"

// DataSource Protocol
@protocol skyHDMIMatrixSettingDataSource <NSObject>

// 获取当前HDMI矩阵输入路数
- (int)getCurrentHDMIInputs;
// 设置当前HDMI矩阵输入路数
- (void)setCurrentHDMIInputs:(int)nInputs;

@end

// class skyHDMIMatrixSetting
@interface skyHDMIMatrixSetting : skyPopBaseViewController<UITableViewDelegate,UITableViewDataSource>

//////////////////// Property //////////////////////
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) UISwitch *useHDMISwitch;
@property (strong, nonatomic) id<skyHDMIMatrixSettingDataSource> myDataSource;

//////////////////// Methods ///////////////////////

//////////////////// Ends //////////////////////////

@end
