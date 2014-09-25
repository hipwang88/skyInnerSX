//
//  skySettingSignalVC.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyPopBaseViewController.h"
#import "skyCVBSMatrixSetting.h"
#import "skyVGAMatrixSetting.h"
#import "skyHDMIMatrixSetting.h"
#import "skyDVIMatrixSetting.h"

// DataSource Protocol
@protocol skySettingSignalVCDataSource <NSObject>

// CVBS矩阵设置
- (void)setCVBSMatrixInputs:(int)nInputs;
- (int)getCVBSMatrixInputs;

// VGA矩阵设置
- (void)setVGAMatrixInputs:(int)nInputs;
- (int)getVGAMatrixInputs;

// HDMI矩阵设置
- (void)setHDMIMatrixInputs:(int)nInputs;
- (int)getHDMIMatrixInputs;

// DVI矩阵设置
- (void)setDVIMatrixInputs:(int)nInputs;
- (int)getDVIMatrixInputs;

@end

// class skySettingSignalVC
// Protocol:
//          skyCVBSMatrixSettignDataSource  --- CVBS矩阵设置数据源
//          skyVGAMatrixSettingDataSource   --- VGA矩阵设置数据源
//          skyHDMIMatrixSettingDataSource  --- HDMI矩阵设置数据源
//          skyDVIMatrixSettingDataSource   --- DVI矩阵设置数据源
//
@interface skySettingSignalVC : skyPopBaseViewController<UITableViewDelegate,UITableViewDataSource,skyCVBSMatrixSettingDataSource,skyVGAMatrixSettingDataSource,skyHDMIMatrixSettingDataSource>

//////////////////////// Property /////////////////////////////
@property (strong, nonatomic) NSMutableArray *matrixs;                          // Signal Setting页面内控制器装载容器
@property (strong, nonatomic) id<skySettingSignalVCDataSource> myDataSource;    // 数据源

//////////////////////// Methods //////////////////////////////

//////////////////////// Ends /////////////////////////////////

@end
