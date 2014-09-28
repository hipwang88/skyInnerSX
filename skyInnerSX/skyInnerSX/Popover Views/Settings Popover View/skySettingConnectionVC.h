//
//  skySettingConnectionVC.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyPopBaseViewController.h"

// DataSource Protocol
@protocol skySettingConnectionVCDataSource <NSObject>

// 获取当前IP地址
- (NSString *)getCurrentIPAddress;
// 获取当前端口号
- (int)getCurrentPortNumber;
// 设置当前控制器IP地址和端口
- (void)setCurrentIPAddress:(NSString *)ipAddress andPort:(int)nPort;

@end

// Delegate Protocol
@protocol skySettingConnectionVCDelegate <NSObject>

// 连接控制器
- (void)connectToController:(NSString *)ipAddress andPort:(int)nPort;
// 断开控制器
- (void)disconnectController;

@end

// class skySettingConnectionVC
@interface skySettingConnectionVC : skyPopBaseViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

//////////////////////// Property /////////////////////////////
@property (strong, nonatomic) UITextField *serverIP;                                // IP地址输入栏
@property (strong, nonatomic) UITextField *serverPort;                              // 服务器端口输入栏
@property (strong, nonatomic) UISwitch *connectionSwitch;                           // 连接开关
@property (strong, nonatomic) id<skySettingConnectionVCDelegate> myDelegate;        // 代理
@property (strong, nonatomic) id<skySettingConnectionVCDataSource> myDataSource;    // 数据源

//////////////////////// Methods //////////////////////////////
// 控制器是否能够连接
- (void)controllerCanBeConnected:(BOOL)bFlag;

//////////////////////// Ends /////////////////////////////////

@end
