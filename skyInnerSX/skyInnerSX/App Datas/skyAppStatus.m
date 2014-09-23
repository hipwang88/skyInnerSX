//
//  skyAppStatus.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyAppStatus.h"

@implementation skyAppStatus



#pragma mark - skySettingConnectionVC DataSource
// 获取当前IP地址
- (NSString *)getCurrentIPAddress
{
    return @"172.16.16.10";
}

// 获取当前端口号
- (NSInteger)getCurrentPortNumber
{
    return 5000;
}

// 设置当前控制器IP地址和端口
- (void)setCurrentIPAddress:(NSString *)ipAddress andPort:(NSInteger)nPort
{
    
}

@end
