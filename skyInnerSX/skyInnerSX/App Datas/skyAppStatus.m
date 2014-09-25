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

#pragma mark - skySettingConfigVC DataSource
// 获取当前拼接行数
- (NSInteger)getCurrentScreenRow
{
    return 3;
}

// 获取当前拼接列数
- (NSInteger)getCurrentScreenColumn
{
    return 4;
}

// 设置当前行列数
- (void)setCurrentScreenRow:(NSInteger)nRow andColumn:(NSInteger)nColumn
{
    
}

#pragma mark - skySettingSignalVC DataSource
// CVBS矩阵设置
- (void)setCVBSMatrixInputs:(int)nInputs
{
    
}

- (int)getCVBSMatrixInputs
{
    return 6;
}

// VGA矩阵设置
- (void)setVGAMatrixInputs:(int)nInputs
{
    
}

- (int)getVGAMatrixInputs
{
    return 8;
}

// HDMI矩阵设置
- (void)setHDMIMatrixInputs:(int)nInputs
{
    
}

- (int)getHDMIMatrixInputs
{
    return 12;
}

// DVI矩阵设置
- (void)setDVIMatrixInputs:(int)nInputs
{
    
}
- (int)getDVIMatrixInputs
{
    return 0;
}

#pragma mark - skyUnitSelectionVC DataSource
// 获取单元选择数组
- (NSMutableArray *)getCurrentSelectionUnits
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1",@"3",@"5", nil];
    return array;
}

// 设置单元选择数组
- (void)setCurrentSelectionUnits:(NSMutableArray *)selectArray
{
    
}

// 单元全部选择
- (void)selectAllUnit
{
    
}

// 单元全不选
- (void)unSelectAllUnit
{
    
}

// 获取单元总数
- (int)getCountOfUnits
{
    return 12;
}

@end
