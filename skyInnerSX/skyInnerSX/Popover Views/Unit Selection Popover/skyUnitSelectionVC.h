//
//  skyUnitSelectionVC.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-25.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate Protocol
@protocol skyUnitSelectionVCDelegate <NSObject>

// 选择某个机芯单元
- (void)selectOneUnitAtIndex:(int)nIndex;
// 取消选择某个机芯单元
- (void)unSelectOneUnitAtIndex:(int)nIndex;
// 选择全部机芯单元
- (void)selectAllUnit;
// 取消全部选择的机芯单元
- (void)unSelectAllUnit;

@end

// DataSource Protocol
@protocol skyUnitSelectionVCDataSource <NSObject>



@end

// DataSource Protocol

// class skyUnitSelectionVC  --- 屏幕选择视图控制器
@interface skyUnitSelectionVC : UITableViewController

//////////////////// Property /////////////////////////
@property (strong, nonatomic) id<skyUnitSelectionVCDelegate> myDelegate;
@property (strong, nonatomic) id<skyUnitSelectionVCDataSource> myDataSource;

//////////////////// Methods //////////////////////////

//////////////////// Ends /////////////////////////////

@end
