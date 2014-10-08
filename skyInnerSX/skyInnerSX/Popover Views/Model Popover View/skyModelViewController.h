//
//  skyModelViewController.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// DataSource Protocol
@protocol skyModelViewControllerDataSource <NSObject>

// 获取运行截图
- (UIImage *)getModelImageAtIndex:(int)nIndex;
// 保存情景模式状态
- (void)saveModelDataSource;
// 确认情景模式是否可用
- (BOOL)isModelCanBeUsedAtIndex:(int)nIndex;

@end

// Delegate Protocol
@protocol skyModelViewControllerDelegate <NSObject>

// 加载情景模式 -- 拆分大画面
- (void)loadModelSplit:(int)nIndex;
// 加载情景模式 -- 加载屏幕状态
- (void)loadModelScreenStatus:(int)nIndex;
// 加载情景模式 -- 加载信号状态
- (void)loadModelSignalStatus:(int)nIndex;
// 保存情景模式
- (void)shootAppToImage:(int)nIndex;
// 删除情景模式
- (void)removeModelImage:(int)nIndex;

@end

// class skyModelViewController --- 情景模式保存
@interface skyModelViewController : UITableViewController

////////////////////// Property //////////////////////////
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) id<skyModelViewControllerDelegate> myDelegate;
@property (strong, nonatomic) id<skyModelViewControllerDataSource> myDataSource;

////////////////////// Methods ///////////////////////////
// 情景模式状态保存
- (void)saveModelStatusToFile;

////////////////////// Ends //////////////////////////////

@end
