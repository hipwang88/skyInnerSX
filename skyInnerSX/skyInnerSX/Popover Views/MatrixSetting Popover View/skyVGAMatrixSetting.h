//
//  skyVGAMatrixSetting.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-24.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyPopBaseViewController.h"

// DataSource Protocol
@protocol skyVGAMatrixSettingDataSource <NSObject>

// 获取当前VGA输入路数
- (int)getCurrentVGAInputs;
// 设置当前VGA输入路数
- (void)setCurrentVGAInputs:(int)nInputs;

@end

@interface skyVGAMatrixSetting : skyPopBaseViewController<UITableViewDelegate,UITableViewDataSource>

///////////////////// Property //////////////////////////
@property (strong, nonatomic) IBOutlet UITableView *myTableView;                // Table View 对象
@property (strong, nonatomic) UISwitch *useVGASwitch;                           // VGA矩阵启用开关
@property (strong, nonatomic) id<skyVGAMatrixSettingDataSource> myDataSource;   // 数据源

///////////////////// Methods ///////////////////////////

///////////////////// Ends //////////////////////////////

@end
