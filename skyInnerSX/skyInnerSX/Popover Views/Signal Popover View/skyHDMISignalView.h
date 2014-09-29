//
//  skyHDMISignalView.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-29.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// DataSource Protocol
@protocol skyHDMISignalViewDataSource <NSObject>

// 获取矩阵输入路数
- (int)getHDMIMatrixInputs;
// 获取矩阵别名
- (NSString *)getHDMIMatrixAliasAtIndex:(int)nIndex;

@end

// Delegate Protocol
@protocol  skyHDMISignalViewDelegate <NSObject>

// 信号切换
- (void)haveSignal:(int)nSourceType SwitchTo:(int)nSourcePath;

@end

@interface skyHDMISignalView : UITableViewController

//////////////////// Property ///////////////////////
@property (strong, nonatomic) id<skyHDMISignalViewDelegate> myDelegate;
@property (strong, nonatomic) id<skyHDMISignalViewDataSource> myDataSource;
//////////////////// Methods ////////////////////////

//////////////////// Ends ///////////////////////////

@end

