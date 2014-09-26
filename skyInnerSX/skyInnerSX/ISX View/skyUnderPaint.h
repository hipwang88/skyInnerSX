//
//  skyUnderPaint.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-26.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// DataSource Protocol
@protocol skyUnderPaintDataSource <NSObject>

// 获取拼接行数
- (int)getSpliceRows;
// 获取拼接列数
- (int)getSpliceColumns;
// 获取单元宽度
- (int)getSpliceUnitWidth;
// 获取单元高度
- (int)getSpliceUnitHeight;
// 获取主控区域宽度
- (int)getScreenWidth;
// 获取主控区域高度
- (int)getScreenHeight;

@end

// class skyUnderPaint --- 客户区底图
@interface skyUnderPaint : UIView

/////////////////// Property //////////////////////
@property (strong, nonatomic) id<skyUnderPaintDataSource> myDataSource;

/////////////////// Methods ///////////////////////
// 获取控制区起始点
- (CGPoint)getStartCanvasPoint;
// 规格获取
- (void)getUnderPaintSpec;

/////////////////// Ends //////////////////////////

@end
