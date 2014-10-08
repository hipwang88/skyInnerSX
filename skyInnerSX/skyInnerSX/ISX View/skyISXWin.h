//
//  skyISXWin.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-26.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyISXWinPopoverVC.h"
#import "skyCVBSSignalView.h"
#import "skyVGASignalView.h"
#import "skyHDMISignalView.h"
#import "skyDVISignalView.h"
#import "skyWinBoarder.h"

// Delegate Protocol
@protocol skyISXWinDelegate <NSObject>

// 开始进行缩放或者移动
- (void)isxWinBeginEditing:(id)sender;
// 全局数组数值更新 -- 父控制器中一个维持大画面状态值的数组
- (void)updateBigPicStatusWithStart:(CGPoint)ptStart andSize:(CGSize)szArea withWinNum:(int)nNum;
// 判断窗口是否遇到大画面
- (BOOL)isISXWinCanReachBigPicture:(CGRect)rectFrame;
// 窗口拼接 -- 合成大画面
- (void)isxWinSpliceBigScreen:(id)sender;
// 窗口拼接 -- 切换大画面信号
- (void)isxWinSpliceScreenSignalSwitch:(id)sender;
// 窗口满屏 -- 状态处理
- (void)isxWinFullScreen:(id)sender;
// 大画面分解 -- 拆分
- (void)isxWinResolveBigScreen:(id)sender;
// 大画面分解 -- 状态恢复
- (void)isxWinResolveStatus:(id)sender;
// 信号切换
- (void)isxWin:(id)sender Signal:(int)nType SwitchTo:(int)nChannel;
// 获取数据代理
- (id<skyCVBSSignalViewDataSource>)isxWinCVBSSignalDataSource;
- (id<skyVGASignalViewDataSource>)isxWinVGASignalDataSource;
- (id<skyHDMISignalViewDataSource>)isxWinHDMISignalDataSource;
- (id<skyDVISignalViewDataSource>)isxWinDVISignalDataSource;
- (id<skyISXWinPopoverVCDataSource>)isxWinPopoverVCDataSource;

@end

// DataSource Protocol
@protocol skyISXWinDataSource <NSObject>

// 数据源初始化
- (void)initISXWinDataSource:(id)sender;
// 数据序列化到文件
- (void)saveISXWinDataSource:(id)sender;
// 窗口的情景数据序列化到文件
- (void)saveISXWinModelDataSource:(id)sender AtIndex:(int)nIndex;
// 反序列化窗口情景模式
- (void)loadISXWinModelDataSource:(id)sender AtIndex:(int)nIndex;

@end

// class skyISXWin --- 窗口类
@interface skyISXWin : UIView<UIGestureRecognizerDelegate,skyCVBSSignalViewDelegate,skyVGASignalViewDelegate,skyHDMISignalViewDelegate,skyDVISignalViewDelegate,skyISXWinPopoverVCDelegate>
{
    // 状态开关
    BOOL            bMovable;                                           // 窗口可移动
    BOOL            bScalable;                                          // 窗口可缩放
    BOOL            bBigPicture;                                        // 窗口大画面状态
    // 窗口属性
    int             nWinNumber;                                         // 窗口编号
    int             nSignalType;                                        // 信号类型
    int             nChannelNumber;                                     // 信号通道
    int             nBasicWinWidth;                                     // 基本单元宽度
    int             nBasicWinHeight;                                    // 基本单元高度
    int             nCurrentWinWidth;                                   // 当前窗口宽度
    int             nCurrentWinHeight;                                  // 当前窗口高度
    // 窗口范围
    CGRect          windowRect;
}

////////////////////// Property /////////////////////////
// 窗口属性
@property (assign, nonatomic) int winNumber;                            // 窗口编号
@property (assign, nonatomic) int winSourceType;                        // 信号类型
@property (assign, nonatomic) int winChannelNumber;                     // 信号通道
@property (assign, nonatomic) CGPoint startPoint;                       // 窗口其实位置
@property (assign, nonatomic) CGSize winSize;                           // 窗口纵横跨屏数
@property (assign, nonatomic) CGPoint startCanvas;                      // 画布其实点
@property (assign, nonatomic) CGRect limitRect;                         // 窗口活动限制区域
// 窗口内组件
@property (strong, nonatomic) UILabel *winNumberLabel;                  // 窗口编号组件
@property (strong, nonatomic) UILabel *signalLabel;                     // 信号源通道
@property (strong, nonatomic) UIButton *funcButton;                     // 功能按钮
// 窗口支撑组件
@property (strong, nonatomic) skyWinBoarder *winBoarder;                // 窗口选中外框组件
@property (strong, nonatomic) skyISXWinPopoverVC *isxPop;               // 窗口菜单弹出视图
@property (strong, nonatomic) UIPopoverController *popView;             // 弹出视图
@property (strong, nonatomic) id<skyISXWinDelegate> myDelegate;         // 代理类对象
@property (strong, nonatomic) id<skyISXWinDataSource> myDataSource;     // 数据源对象
// 手势识别组件
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;       // 拖动手势识别器
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;       // 点击手势识别器

////////////////////// Methods //////////////////////////
// 窗口初始
- (id)initWithFrame:(CGRect)frame withRow:(int)nRow andColumn:(int)nColumn;
// 窗口数据初始化
- (void)initializeISXWin:(int)nwinNum;
// 窗口UI更新
- (void)updateWindowUI;
// 切换矩阵
- (void)switchSignal:(int)nType toChannel:(int)nChannel;
// 窗口大小改变
- (void)splitWinStartX:(int)startX StartY:(int)startY HCount:(int)nHcount VCount:(int)nVCount;
// CVBS新建
- (void)newWithCVBS;
// VGA新建
- (void)newWithVGA;
// HDMI新建
- (void)newWithHDMI;
// DVI新建
- (void)newWithDVI;
// 保存状态到文件
- (void)saveISXWinToFile;
// 显示外框
- (void)showBoarderView;
// 隐藏外框
- (void)hideBoarderView;
// 结束缩放后重新刷新窗口 --- 让窗口满屏
- (void)reCaculateISXWinToFullScreen;
// 窗口单屏状态
- (void)setISXWinToSingleStatus;
// 窗口全屏状态
- (void)setISXWinToFullStatus;
// 窗口普通状态
- (void)setISXWinToNormalStatus;
// 保存当前窗口的情景模式
- (void)saveISXWinModelStatusAtIndex:(int)nIndex;
// 加载窗口情景模式
- (void)loadISXWinModelStatusAtIndex:(int)nIndex;

/////////////////////////////////////////////////////////
// 窗口属性setter/getter
- (void)setISXWinMove:(BOOL)bMove;
- (BOOL)getISXWinMove;
- (void)setISXWinScale:(BOOL)bScale;
- (BOOL)getISXWinScale;
- (void)setISXWinBigPicture:(BOOL)bBigPic;
- (BOOL)getISXWinBigPicture;
// 窗口大小setter/getter
- (void)setISXWinBasicWinWidth:(int)nBasicWidth;
- (int)getISXWinBasicWinWidth;
- (void)setISXWinBasicWinHeight:(int)nBasicHeight;
- (int)getISXWinBasicWinHeight;
- (void)setISXWinCurrentWinWidth:(int)nCurrentWidth;
- (int)getISXWinCurrentWinWidth;
- (void)setISXWinCurrentWinHeight:(int)nCurrentHeight;
- (int)getISXWinCurrentWinHeight;

////////////////////// Ends /////////////////////////////

@end
