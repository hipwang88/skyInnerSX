//
//  skyDVISignalView.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-29.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// DataSource Protocol
@protocol skyDVISignalViewDataSource <NSObject>

// 获取矩阵输入路数
- (int)getDVIMatrixInputs;
// 获取矩阵别名
- (NSString *)getDVIMatrixAliasAtIndex:(int)nIndex;

@end

// Delegate Protocol
@protocol  skyDVISignalViewDelegate <NSObject>

// 信号切换
- (void)haveSignal:(int)nSourceType SwitchTo:(int)nSourcePath;

@end

@interface skyDVISignalView : UITableViewController

//////////////////// Property ///////////////////////
@property (strong, nonatomic) id<skyDVISignalViewDelegate> myDelegate;
@property (strong, nonatomic) id<skyDVISignalViewDataSource> myDataSource;
//////////////////// Methods ////////////////////////

//////////////////// Ends ///////////////////////////

@end

