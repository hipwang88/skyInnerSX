//
//  skyDVIMatrixSetting.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-24.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyPopBaseViewController.h"

// DataSource Protocol
@protocol skyDVIMatrixSettingDataSource <NSObject>

// 获取当前DVI矩阵输入路数
- (int)getCurrentDVIInputs;
// 设置当前DVI矩阵输入路数
- (void)setCurrentDVIInputs:(int)nInputs;

@end

// class skyDVIMatrixSetting
@interface skyDVIMatrixSetting : skyPopBaseViewController<UITableViewDelegate,UITableViewDataSource>

////////////////////// Property /////////////////////////
@property (strong, nonatomic) IBOutlet UITableView *myTableView;                // Table View对象
@property (strong, nonatomic) UISwitch *useDVISwitch;                           // DVI矩阵启用开关
@property (strong, nonatomic) id<skyDVIMatrixSettingDataSource> myDataSource;   // 数据源对象

////////////////////// Methods //////////////////////////

////////////////////// Ends /////////////////////////////

@end
