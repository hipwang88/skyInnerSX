//
//  skyISXWinPopoverVC.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyCVBSSignalView.h"
#import "skyVGASignalView.h"
#import "skyHDMISignalView.h"
#import "skyDVISignalView.h"

// skyISXWinPopoverVCDelegate Protocol
@protocol skyISXWinPopoverVCDelegate <NSObject>

// 窗口进入全屏
- (void)enterFullScreen;
// 大画面分解
- (void)splitBigScreen;

@end

// skyISXWinPopoverVCDataSource Protocol
@protocol skyISXWinPopoverVCDataSource <NSObject>

// 获取CVBS矩阵输入
- (int)getCVBSMatrixInputs;
// 获取VGA矩阵输入
- (int)getVGAMatrixInputs;
// 获取HDMI矩阵输入
- (int)getHDMIMatrixInputs;
// 获取DVI矩阵输入
- (int)getDVIMatrixInputs;

@end


@interface skyISXWinPopoverVC : UITableViewController

////////////////////// Property ///////////////////////////
@property (strong, nonatomic) skyCVBSSignalView *cvbsSignalView;
@property (strong, nonatomic) skyVGASignalView *vgaSignalView;
@property (strong, nonatomic) skyHDMISignalView *hdmiSignalView;
@property (strong, nonatomic) skyDVISignalView *dviSignalView;
@property (strong, nonatomic) id<skyISXWinPopoverVCDelegate> myDelegate;
@property (strong, nonatomic) id<skyISXWinPopoverVCDataSource> myDataSource;

////////////////////// Methods ////////////////////////////

////////////////////// Ends ///////////////////////////////

@end
