//
//  skyCVBSSignalView.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-29.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// DataSource Protocol
@protocol skyCVBSSignalViewDataSource <NSObject>

// 获取矩阵输入路数
- (int)getCVBSMatrixInputs;
// 获取矩阵别名
- (NSString *)getCVBSMatrixAliasAtIndex:(int)nIndex;

@end

// Delegate Protocol
@protocol  skyCVBSSignalViewDelegate <NSObject>

// 信号切换
- (void)haveSignal:(int)nSourceType SwitchTo:(int)nSourcePath;

@end

@interface skyCVBSSignalView : UITableViewController

//////////////////// Property ///////////////////////
@property (strong, nonatomic) id<skyCVBSSignalViewDelegate> myDelegate;
@property (strong, nonatomic) id<skyCVBSSignalViewDataSource> myDataSource;
//////////////////// Methods ////////////////////////

//////////////////// Ends ///////////////////////////

@end
