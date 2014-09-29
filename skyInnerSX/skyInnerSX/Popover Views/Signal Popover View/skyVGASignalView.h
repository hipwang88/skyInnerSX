//
//  skyVGASignalView.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-29.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// DataSource Protocol
@protocol skyVGASignalViewDataSource <NSObject>

// 获取VGA矩阵输入路数
- (int)getVGAMatrixInputs;
// 获取VGA矩阵输入通道别名
- (NSString *)getVGAMatrixAliasAtIndex:(int)nIndex;

@end

// Delegate Protocol
@protocol  skyVGASignalViewDelegate <NSObject>

// 信号切换
- (void)haveSignal:(int)nSourceType SwitchTo:(int)nSourcePath;

@end

@interface skyVGASignalView : UITableViewController

//////////////////// Property ///////////////////////
@property (strong, nonatomic) id<skyVGASignalViewDelegate> myDelegate;
@property (strong, nonatomic) id<skyVGASignalViewDataSource> myDataSource;
//////////////////// Methods ////////////////////////

//////////////////// Ends ///////////////////////////

@end

