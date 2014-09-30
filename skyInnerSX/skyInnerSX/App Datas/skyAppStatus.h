//
//  skyAppStatus.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "skySettingConnectionVC.h"
#import "skySettingConfigVC.h"
#import "skySettingSignalVC.h"
#import "skySettingUnitVC.h"
#import "skyUnderPaint.h"
#import "skyISXWin.h"
#import "skyCVBSSignalView.h"
#import "skyVGASignalView.h"
#import "skyHDMISignalView.h"
#import "skyDVISignalView.h"
#import "skyModelViewController.h"

//
// Screen Size
#define APPVIEWWIDTH                1024                // 用户区界面宽度
#define APPVIEWHEIGHT               704                 // 用户区界面高度
//
// SandBox File
#define APPBASICFILE                @"appBasicDatas"
#define APPSIGNALFILE               @"appSignalDatas"
#define APPUNITSELECTIONFILE        @"appUnitSelectionDatas"
#define APPMODELSAVEFILE            @"appModelSaveDatas"
//
// Basic Datas key
#define kAPPROWS                    @"appRows"
#define kAPPCOLUMNS                 @"appColumns"
#define kAPPUNITWIDTH               @"appUnitWidth"
#define kAPPUNITHEIGHT              @"appUnitHeight"
#define kAPPSCREENWIDTH             @"appScreenWidth"
#define kAPPSCREENHEIGHT            @"appScreenHeight"
#define kAPPIPADDRESS               @"appIPAddress"
#define kAPPPORTNUMBER              @"appPortNumber"        
#define kAPPCVBSINPUTS              @"appCVBSInputs"
#define kAPPVGAINPUTS               @"appVGAInputs"
#define kAPPHDMIINPUTS              @"appHDMIInputs"
#define kAPPDVIINPUTS               @"appDVIInputs"
//
// Unit Selection Key
#define kUNITSELECTIONS             @"appUnitSelections"
//
// ISX Window
#define kISXWINSTARTX               @"skyISXWin_StartX"
#define kISXWINSTARTY               @"skyISXWin_StartY"
#define kISXWINSIZEW                @"skyISXWin_Size.W"
#define kISXWINSIZEH                @"skyISXWin_Size.H"
#define kISXWINMOVE                 @"skyISXWin_Move"
#define kISXWINSCALE                @"skyISXWin_Scale"
#define kISXWINBIGPIC               @"skyISXWin_BigPicture"
#define kISXWINSIGNALTYPE           @"skyISXWin_SignalType"
#define kISXWINCHANNELNUM           @"skyISXWin_ChannelNum"
#define kISXWINBWIDTH               @"skyISXWin_BasicWidth"
#define kISXWINBHEIGHT              @"skyISXWin_BasicHeight"
#define kISXWINCWIDTH               @"skyISXWin_CurrentWidth"
#define kISXWINCHEIGHT              @"skyISXWin_CurrentHeight"

// class skyAppStatus
// DataSource:
//              skySettingConnectionVCDataSource --- 通信设置数据源
//              skySettingConfigVCDataSource     --- 规格设置数据源
//              skySettingSignalVCDataSource     --- 信号源设置数据源
//              skyUnitSelectionVCDataSource     --- 单元选择数据源
//              skyUnderPaintDataSource          --- 主客户区底图数据源
//              skyISXWinDataSource              --- 拼接窗口数据源
//              sky**SignalViewDataSource        --- 窗口信号切换视图数据源
//              skyISXWinPopoverVCDataSource     --- 拼接窗口弹出视图数据源
//              skyModelViewControllerDataSource --- 情景模式数据源 
//
@interface skyAppStatus : NSObject<skySettingConnectionVCDataSource,skySettingConfigVCDataSource,skySettingSignalVCDataSource,skyUnitSelectionVCDataSource,skyUnderPaintDataSource,skyISXWinDataSource,skyCVBSSignalViewDataSource,skyVGASignalViewDataSource,skyHDMISignalViewDataSource,skyDVISignalViewDataSource,skyISXWinPopoverVCDataSource,skyModelViewControllerDataSource>

/////////////////////////// Property ///////////////////////////////
// 程序基本运行数据字典
@property (strong, nonatomic) NSMutableDictionary *appBasicDic;
// 信号源数据字典
@property (strong, nonatomic) NSMutableDictionary *appSignalDic;
// 屏幕选择数据字典
@property (strong, nonatomic) NSMutableDictionary *appUnitSelectionDic;
// 情景模式数据字典
@property (strong, nonatomic) NSMutableDictionary *appModelSaveDic;
// 屏幕选择状态数组
@property (strong, nonatomic) NSMutableArray *appUnitSelectionArray;
// 情景模式保存图片数组
@property (strong, nonatomic) NSMutableArray *appModelSaveImageArray;

// Basic Runtime Datas Property
@property (strong, nonatomic) NSString *appIPAddress;           // 服务端IP
@property (assign, nonatomic) int       appPortNumber;          // 服务端端口
@property (assign, nonatomic) int       appScreenRows;          // 拼接行数
@property (assign, nonatomic) int       appScreenColumns;       // 拼接列数
@property (assign, nonatomic) int       appUnitWidth;           // 单元宽度
@property (assign, nonatomic) int       appUnitHeight;          // 单元高度
@property (assign, nonatomic) int       appScreenWidth;         // 屏幕宽度
@property (assign, nonatomic) int       appScreenHeight;        // 屏幕高度
@property (assign, nonatomic) int       appCVBSMatrixInputs;    // CVBS矩阵输入路数
@property (assign, nonatomic) int       appVGAMatrixInputs;     // VGA矩阵输入路数
@property (assign, nonatomic) int       appHDMIMatrixInputs;    // HDMI矩阵输入路数
@property (assign, nonatomic) int       appDVIMatrixInputs;     // DVI矩阵输入路数

/////////////////////////// Methods ////////////////////////////////
// 运行数据保存
- (void)appStatusSave;
// 计算控制区域
- (void)calculateWorkingArea;
// 情景保存图片存储
- (void)saveModelImage:(UIImage *)image toIndex:(NSInteger)nIndex;
// 情景保存图片删除
- (void)deleteModelImageAtIndex:(NSInteger)nIndex;
// 删除普通窗口数据文件
- (void)deleteISXWindowData;
// 删除情景模式记录
- (void)deleteAllModelData;


/////////////////////////// Ends ///////////////////////////////////

@end
