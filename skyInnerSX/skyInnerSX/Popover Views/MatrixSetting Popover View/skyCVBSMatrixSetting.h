//
//  skyCVBSMatrixSetting.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-24.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyPopBaseViewController.h"


// DataSource Protocol
@protocol skyCVBSMatrixSettingDataSource <NSObject>

// 获取CVBS矩阵使用输入路数
- (int)getCurrentCVBSInputs;
// 设置CVBS矩阵使用输入路数
- (void)setCurrentCVBSInputs:(int)nInputs;

@end

// class skyCVBSMatrixSetting
@interface skyCVBSMatrixSetting : skyPopBaseViewController<UITableViewDelegate,UITableViewDataSource>

///////////////////// Property /////////////////////////
@property (strong, nonatomic) IBOutlet UITableView *myTableView;                // 视图TableView对象
@property (strong, nonatomic) UISwitch *useCVBSSwitch;                          // CVBS矩阵使用开关
@property (strong, nonatomic) id<skyCVBSMatrixSettingDataSource> myDataSource;  // 数据对象

///////////////////// Methods //////////////////////////

///////////////////// Ends /////////////////////////////

@end
