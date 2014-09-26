//
//  skyInner6M48TVSDK.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-26.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "definitions.h"

// class skyInner6M48TVSDK --- 内置拼接6M48开放协议
@interface skyInner6M48TVSDK : NSObject

/////////////////// Property //////////////////////

/////////////////// Methods ///////////////////////
// 初始化开放协议SDK
- (id)initOpenSCXProtocol;
// 连接TCP服务器
- (BOOL)connectTCPService:(NSString *)hostAddress andPort:(int)nPort;
// 端口TCP服务器
- (void)disconnectWithTCPService;
// 服务器重连
- (void)reConnectToService;
// 服务器进入后台
- (void)serviceEnterBackground;

/*************************************************/
// 1.显示编号
- (void)innerSXShowNumber;
// 2.隐藏编号
- (void)innerSXHideNumber;
// 3.屏幕开机
- (void)innerSXScreenOn;
// 4.屏幕关机
- (void)innerSXScreenOff;
// 5.屏幕全选
- (void)innerSXSelectAll;
// 6.屏幕全不选
- (void)innerSXSelectNone;
// 7.选中一个单元
- (void)innerSXSelectOneUnit:(int)nIndex;
// 8.取消某个单元选中
- (void)innerSXUnSelectOneUnit:(int)nIndex;
// 9.位置自动调整
- (void)innerSXAdjustPosition;
// 10.白平衡自动调整
- (void)innerSXAdjustWB;
// 11.亮度增大
- (void)innerSXBrightnessIncrease;
// 12.亮度减小
- (void)innerSXBrightnessDecrease;
// 13.亮度复位
- (void)innerSXBrightnessReset;
// 14.对比度增大
- (void)innerSXContrastIncrease;
// 15.对比度减小
- (void)innerSXContrastDecrease;
// 16.对比度复位
- (void)innerSXContrastReset;
// 17.大画面拼接 -- 合成
- (void)innerSXSpliceScreen:(int)nWin StartAt:(int)nStartPanel VCountNum:(int)nVCount HCountNum:(int)nHCount;
// 17.大画面拼接 -- 信号切换
- (void)innerSXSwitchBigScreen:(int)nWin toSrcType:(int)nType atSrcPath:(int)nPath;
// 18.大画面分解 -- 拆分
- (void)innerSXSplitBigScreen:(int)nWin StartAt:(int)nStartPanel VCountNum:(int)nVCount HCountNum:(int)nHCount;
// 18.大画面分解 -- 状态恢复
- (void)innerSXResolveScreen:(int)nWin StartAt:(int)nStartPanel VCountNum:(int)nVCount HCountNum:(int)nHCount;
// 19.分解所有大画面
- (void)innerSXSplitAllBigScreens;
// 20.单画面信号切换
- (void)innerSXSingleScreen:(int)nWin SwitchSrcType:(int)nType toSrcPath:(int)nPath;
// 21.大画面信号切换
- (void)innerSXBigScreen:(int)nWin SwitchSrcType:(int)nType toSrcPath:(int)nPath;
// 22.情景模式保存
- (void)innerSXModelSave:(int)nIndex;
// 23.情景模式加载 -- 拆分大画面
- (void)innerSXLoadModelSplit;
// 23.情景模式加载 -- 加载大画面参数
- (void)innerSXLoadModelParameter:(int)nIndex;
// 23.情景模式加载 -- 加载信号、通道、单元状态
- (void)innerSXLoadModel:(int)nIndex;
// 24.情景模式新建 -- CVBS新建
- (void)innerSXModelNewWithCVBS;
// 24.情景模式新建 -- VGA新建
- (void)innerSXModelNewWithVGA;
// 24.情景模式新建 -- HDMI新建
- (void)innerSXModelNewWithHDMI;
// 25.拼接规格设定
- (void)innerSXSetSpliceRow:(int)nRow andColumn:(int)nColumn;
/*************************************************/

/////////////////// Ends //////////////////////////

@end
