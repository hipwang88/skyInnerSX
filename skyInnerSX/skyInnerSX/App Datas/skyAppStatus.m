//
//  skyAppStatus.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyAppStatus.h"

// Private
@interface skyAppStatus()

// 应用程序状态类初始化
- (void)appStatusInit;
// 应用程序基本数据初始
- (void)initBasicAppDatas;
// 单元选择数据初始
- (void)initUnitSelectionDatas;
// 初始化信号源数据
- (void)initSignalDatas;
// 初始化情景模式数据
- (void)initModelDatas;

// 应用程序基本数据保存
- (void)saveBasicAppDatas;
// 单元选择数据保存
- (void)saveUnitSelectionDatas;

@end

@implementation skyAppStatus

@synthesize appBasicDic = _appBasicDic;
@synthesize appSignalDic = _appSignalDic;
@synthesize appUnitSelectionDic = _appUnitSelectionDic;
@synthesize appModelSaveDic = _appModelSaveDic;
@synthesize appUnitSelectionArray = _appUnitSelectionArray;
@synthesize appModelSaveImageArray = _appModelSaveImageArray;
@synthesize appIPAddress = _appIPAddress;
@synthesize appPortNumber = _appPortNumber;
@synthesize appScreenRows = _appScreenRows;
@synthesize appScreenColumns = _appScreenColumns;
@synthesize appScreenWidth = _appScreenWidth;
@synthesize appScreenHeight = _appScreenHeight;
@synthesize appUnitWidth = _appUnitWidth;
@synthesize appUnitHeight = _appUnitHeight;
@synthesize appCVBSMatrixInputs = _appCVBSMatrixInputs;
@synthesize appVGAMatrixInputs = _appVGAMatrixInputs;
@synthesize appHDMIMatrixInputs = _appHDMIMatrixInputs;
@synthesize appDVIMatrixInputs = _appDVIMatrixInputs;

#pragma mark - Public Methods
// 类初始化
- (id)init
{
    self = [super init];
    if (self)
    {
        // 应用程序初始化
        [self appStatusInit];
    }
    
    return self;
}

// 运行数据保存
- (void)appStatusSave
{
    // 应用程序基本数据保存
    [self saveBasicAppDatas];
    // 单元选择数据保存
    [self saveUnitSelectionDatas];
}

// 计算控制区域
- (void)calculateWorkingArea
{
    int nTempWidth,nTempHeight,nTotalWidth,nTotalHeight,nRatioX,nRatioY,nInt;
    
    nTotalWidth = 1150;
    nTotalHeight = 600;
    nRatioX = 4;
    nRatioY = 3;
    nTempWidth = nTempHeight = 0;
    
    if (_appScreenRows < _appScreenColumns)
    {
        nTempWidth = (nTotalWidth / (2*_appScreenColumns)) * 0.8;
        
        nInt = nTempWidth / nRatioX;
        nTempHeight = nInt * nRatioY;
    }
    else if (_appScreenRows >= _appScreenColumns)
    {
        nTempHeight = nTotalHeight / (2*_appScreenRows);
        
        nInt = nTempHeight / nRatioY;
        nTempWidth = nInt * nRatioX;
    }
    
    _appUnitWidth = nTempWidth;
    _appUnitHeight = nTempHeight;
    
    _appScreenWidth = nTempWidth * _appScreenColumns * 2;
    _appScreenHeight = nTempHeight * _appScreenRows * 2;
}

// 情景保存图片存储
- (void)saveModelImage:(UIImage *)image toIndex:(NSInteger)nIndex
{
    NSString *modelKey = [NSString stringWithFormat:@"Model-%ld",nIndex+1];
    // 将情景标志置换
    [_appModelSaveDic setObject:@"1" forKey:modelKey];
    
    // 替换图片数组
    [_appModelSaveImageArray replaceObjectAtIndex:nIndex withObject:image];
}

// 情景保存图片删除
- (void)deleteModelImageAtIndex:(NSInteger)nIndex
{
    NSString *modelKey = [NSString stringWithFormat:@"Model-%ld",nIndex+1];
    // 将情景标志置换
    [_appModelSaveDic setObject:@"0" forKey:modelKey];
    
    UIImage *image = [UIImage imageNamed:@"notsaved.png"];
    // 替换图片数组
    [_appModelSaveImageArray replaceObjectAtIndex:nIndex withObject:image];
}

// 删除普通窗口数据文件
- (void)deleteISXWindowData
{
    // 一个叠加窗口一个保存文件 文件名：skySubWin_X X-编号
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appStandardDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStandard"];
    
    [[NSFileManager defaultManager] removeItemAtPath:appStandardDir error:nil];
}

// 删除情景模式记录
- (void)deleteAllModelData
{
    for (int i = 0; i < 18; i++)
    {
        [self deleteModelImageAtIndex:i];
    }
}


#pragma mark - Private Methods
// 应用程序状态类初始化
- (void)appStatusInit
{
    // 应用程序基本数据初始
    [self initBasicAppDatas];
    // 单元选择数据初始
    [self initUnitSelectionDatas];
    // 初始化信号源数据
    [self initSignalDatas];
    // 初始化情景模式数据
    [self initModelDatas];
}

// 应用程序基本数据初始
- (void)initBasicAppDatas
{
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appDefaultDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStatus"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appDefaultDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appDefaultDir stringByAppendingPathComponent:APPBASICFILE];
    
    // 从文件中初始化数据字典
    self.appBasicDic = [[NSMutableDictionary alloc] initWithContentsOfFile:appDefaultFileName];
    // 初始运行无文件
    if (!self.appBasicDic)
    {
        // 创建数据字典
        self.appBasicDic = [[NSMutableDictionary alloc] init];
        
        // 初始默认值
        _appScreenRows = 2;
        _appScreenColumns = 3;
        
        // 主控区域计算
        [self calculateWorkingArea];
        
        // 服务端信息
        _appIPAddress = @"172.16.16.101";
        _appPortNumber = 5000;
        // 矩阵输入路数信息
        _appCVBSMatrixInputs = 12;
        _appVGAMatrixInputs = 8;
        _appHDMIMatrixInputs = 4;
        _appDVIMatrixInputs = 0;
        
        // 保存数据
        [_appBasicDic setObject:[NSString stringWithFormat:@"%@",_appIPAddress] forKey:kAPPIPADDRESS];
        [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appPortNumber] forKey:kAPPPORTNUMBER];
        [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appScreenRows] forKey:kAPPROWS];
        [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appScreenColumns] forKey:kAPPCOLUMNS];
        [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appUnitWidth] forKey:kAPPUNITWIDTH];
        [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appUnitHeight] forKey:kAPPUNITHEIGHT];
        [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appScreenWidth] forKey:kAPPSCREENWIDTH];
        [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appScreenHeight] forKey:kAPPSCREENHEIGHT];
        [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appCVBSMatrixInputs] forKey:kAPPCVBSINPUTS];
        [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appVGAMatrixInputs] forKey:kAPPVGAINPUTS];
        [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appHDMIMatrixInputs] forKey:kAPPHDMIINPUTS];
        [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appDVIMatrixInputs] forKey:kAPPDVIINPUTS];
        
        // 字典写入数据文件
        [_appBasicDic writeToFile:appDefaultFileName atomically:YES];
    }
    else
    {
        // 文件存在则读取数据
        _appIPAddress = [_appBasicDic objectForKey:kAPPIPADDRESS];
        _appPortNumber = [[_appBasicDic objectForKey:kAPPPORTNUMBER] intValue];
        _appScreenRows = [[_appBasicDic objectForKey:kAPPROWS] intValue];
        _appScreenColumns = [[_appBasicDic objectForKey:kAPPCOLUMNS] intValue];
        _appUnitWidth = [[_appBasicDic objectForKey:kAPPUNITWIDTH] intValue];
        _appUnitHeight = [[_appBasicDic objectForKey:kAPPUNITHEIGHT] intValue];
        _appScreenWidth = [[_appBasicDic objectForKey:kAPPSCREENWIDTH] intValue];
        _appScreenHeight = [[_appBasicDic objectForKey:kAPPSCREENHEIGHT] intValue];
        _appCVBSMatrixInputs = [[_appBasicDic objectForKey:kAPPCVBSINPUTS] intValue];
        _appVGAMatrixInputs = [[_appBasicDic objectForKey:kAPPVGAINPUTS] intValue];
        _appHDMIMatrixInputs = [[_appBasicDic objectForKey:kAPPHDMIINPUTS] intValue];
        _appDVIMatrixInputs = [[_appBasicDic objectForKey:kAPPDVIINPUTS] intValue];
    }
}

// 单元选择数据初始
- (void)initUnitSelectionDatas
{
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appDefaultDir = [appDefaultsPath stringByAppendingPathComponent:@"UCStatus"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appDefaultDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appDefaultDir stringByAppendingPathComponent:APPUNITSELECTIONFILE];

    // 从文件初始数据字典
    self.appUnitSelectionDic = [[NSMutableDictionary alloc] initWithContentsOfFile:appDefaultFileName];
    // 初始运行无文件数据
    if (!self.appUnitSelectionDic)
    {
        // 创建数据字典
        self.appUnitSelectionDic = [[NSMutableDictionary alloc] init];
        
        // 创建单元选择数组
        self.appUnitSelectionArray = [[NSMutableArray alloc] init];
        
        // 保存数据
        [_appUnitSelectionDic setObject:_appUnitSelectionArray forKey:kUNITSELECTIONS];
        
        // 字典写入数据文件
        [_appUnitSelectionDic writeToFile:appDefaultFileName atomically:YES];
    }
    else
    {
        // 文件存在则获取数据
        _appUnitSelectionArray = [_appUnitSelectionDic objectForKey:kUNITSELECTIONS];
    }
}

// 初始化信号源数据
- (void)initSignalDatas
{
    
}

// 初始化情景模式数据
- (void)initModelDatas
{
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appDefaultDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStatus"];
    NSString *appModelImageDir = [appDefaultsPath stringByAppendingPathComponent:@"ModelSavedImages"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appDefaultDir withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:appModelImageDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appDefaultDir stringByAppendingPathComponent:APPMODELSAVEFILE];
    
    // 从文件中初始化字典
    self.appModelSaveDic = [[NSMutableDictionary alloc] initWithContentsOfFile:appDefaultFileName];
    // 初始化情景图片数组
    self.appModelSaveImageArray = [[NSMutableArray alloc] init];
    
    // 如果没有此文件
    if (!self.appModelSaveDic)
    {
        // 创建此字典
        self.appModelSaveDic = [[NSMutableDictionary alloc] init];
        
        // 默认数值设定
        for (int i = 1; i <= 18; i++)
        {
            NSString *modelKey = [NSString stringWithFormat:@"Model-%d",i];
            int nValue = 0;
            
            // 写入字典
            [_appModelSaveDic setObject:[NSString stringWithFormat:@"%d",nValue] forKey:modelKey];
        }
    }
    
    // 提取图片数组
    for (int i = 1; i <= 18; i++)
    {
        NSString *modelKey = [NSString stringWithFormat:@"Model-%d",i];
        NSInteger nValue = [[_appModelSaveDic objectForKey:modelKey] integerValue];
        UIImage *image;
        NSString *imagePath = [appModelImageDir stringByAppendingPathComponent:[NSString stringWithFormat:@"model_%d.png",i]];
        
        switch (nValue) {
            case 0: // 情景未保存
                image = [UIImage imageNamed:@"notsaved.png"];
                [_appModelSaveImageArray addObject:image];
                break;
                
            case 1: // 情景已经保存
                image = [UIImage imageWithContentsOfFile:imagePath];
                [_appModelSaveImageArray addObject:image];
                break;
        }
    }
}

// 应用程序基本数据保存
- (void)saveBasicAppDatas
{
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appDefaultDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStatus"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appDefaultDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appDefaultDir stringByAppendingPathComponent:APPBASICFILE];
    
    // 保存数据
    [_appBasicDic setObject:[NSString stringWithFormat:@"%@",_appIPAddress] forKey:kAPPIPADDRESS];
    [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appPortNumber] forKey:kAPPPORTNUMBER];
    [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appScreenRows] forKey:kAPPROWS];
    [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appScreenColumns] forKey:kAPPCOLUMNS];
    [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appUnitWidth] forKey:kAPPUNITWIDTH];
    [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appUnitHeight] forKey:kAPPUNITHEIGHT];
    [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appScreenWidth] forKey:kAPPSCREENWIDTH];
    [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appScreenHeight] forKey:kAPPSCREENHEIGHT];
    [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appCVBSMatrixInputs] forKey:kAPPCVBSINPUTS];
    [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appVGAMatrixInputs] forKey:kAPPVGAINPUTS];
    [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appHDMIMatrixInputs] forKey:kAPPHDMIINPUTS];
    [_appBasicDic setObject:[NSString stringWithFormat:@"%d",_appDVIMatrixInputs] forKey:kAPPDVIINPUTS];
    
    // 字典写入数据文件
    [_appBasicDic writeToFile:appDefaultFileName atomically:YES];
}

// 单元选择数据保存
- (void)saveUnitSelectionDatas
{
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appDefaultDir = [appDefaultsPath stringByAppendingPathComponent:@"UCStatus"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appDefaultDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appDefaultDir stringByAppendingPathComponent:APPUNITSELECTIONFILE];
    
    // 保存数据
    [_appUnitSelectionDic setObject:_appUnitSelectionArray forKey:kUNITSELECTIONS];
    
    // 字典写入数据文件
    [_appUnitSelectionDic writeToFile:appDefaultFileName atomically:YES];
}

#pragma mark - skySettingConnectionVC DataSource
// 获取当前IP地址
- (NSString *)getCurrentIPAddress
{
    return _appIPAddress;
}

// 获取当前端口号
- (int)getCurrentPortNumber
{
    return _appPortNumber;
}

// 设置当前控制器IP地址和端口
- (void)setCurrentIPAddress:(NSString *)ipAddress andPort:(int)nPort
{
    _appIPAddress = ipAddress;
    _appPortNumber = nPort;
}

#pragma mark - skySettingConfigVC DataSource
// 获取当前拼接行数
- (int)getCurrentScreenRow
{
    return _appScreenRows;
}

// 获取当前拼接列数
- (int)getCurrentScreenColumn
{
    return _appScreenColumns;
}

// 设置当前行列数
- (void)setCurrentScreenRow:(int)nRow andColumn:(int)nColumn
{
    // 清空单元选择
    [_appUnitSelectionArray removeAllObjects];
    // 更改规格
    _appScreenRows = nRow;
    _appScreenColumns = nColumn;
}

#pragma mark - skySettingSignalVC DataSource
// CVBS矩阵设置
- (void)setCVBSMatrixInputs:(int)nInputs
{
    _appCVBSMatrixInputs = nInputs;
}

- (int)getCVBSMatrixInputs
{
    return _appCVBSMatrixInputs;
}

// VGA矩阵设置
- (void)setVGAMatrixInputs:(int)nInputs
{
    _appVGAMatrixInputs = nInputs;
}

- (int)getVGAMatrixInputs
{
    return _appVGAMatrixInputs;
}

// HDMI矩阵设置
- (void)setHDMIMatrixInputs:(int)nInputs
{
    _appHDMIMatrixInputs = nInputs;
}

- (int)getHDMIMatrixInputs
{
    return _appHDMIMatrixInputs;
}

// DVI矩阵设置
- (void)setDVIMatrixInputs:(int)nInputs
{
    _appDVIMatrixInputs = nInputs;
}
- (int)getDVIMatrixInputs
{
    return _appDVIMatrixInputs;
}

#pragma mark - skyUnitSelectionVC DataSource
// 获取单元选择数组
- (NSMutableArray *)getCurrentSelectionUnits
{
    return _appUnitSelectionArray;
}

// 设置单元选择数组
- (void)setCurrentSelectionUnits:(NSMutableArray *)selectArray
{
    _appUnitSelectionArray = selectArray;
}

// 单元全部选择
- (void)selectAllUnit
{
    int nCounts = _appScreenRows * _appScreenColumns;
    
    [_appUnitSelectionArray removeAllObjects];
    for (int i = 1; i <= nCounts; i++)
    {
        [_appUnitSelectionArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
}

// 单元全不选
- (void)unSelectAllUnit
{
    [_appUnitSelectionArray removeAllObjects];
}

// 获取单元总数
- (int)getCountOfUnits
{
    return _appScreenRows*_appScreenColumns;
}

#pragma mark - skyUnderPaint DataSource
// 获取拼接行数
- (int)getSpliceRows
{
    return _appScreenRows;
}

// 获取拼接列数
- (int)getSpliceColumns
{
    return _appScreenColumns;
}

// 获取单元宽度
- (int)getSpliceUnitWidth
{
    return _appUnitWidth;
}

// 获取单元高度
- (int)getSpliceUnitHeight
{
    return _appUnitHeight;
}

// 获取主控区域宽度
- (int)getScreenWidth
{
    return _appScreenWidth;
}

// 获取主控区域高度
- (int)getScreenHeight
{
    return _appScreenHeight;
}

#pragma mark - skyISXWin DataSource
// 数据源初始化
- (void)initISXWinDataSource:(id)sender
{
    skyISXWin *isxWin = (skyISXWin *)sender;
    int nWinNum = isxWin.winNumber;
    
    // 一个窗口一个文件 拼接窗口 skyISXWin_X X-nWinNum
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appStandardDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStandard"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appStandardDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appStandardDir stringByAppendingPathComponent:[NSString stringWithFormat:@"skyISXWin_%d",nWinNum]];
    
    // 字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:appDefaultFileName];
    if (!dict)
    {
        // 如果没有这样的文件 就重新创建字典
        dict = [[NSMutableDictionary alloc] init];
        
        // 用窗口的默认值写入文件
        // 棋盘数据
        isxWin.startPoint = CGPointMake((nWinNum-1)%_appScreenColumns, (nWinNum-1)/_appScreenColumns);
        isxWin.winSize = CGSizeMake(1, 1);
        // 窗口状态开关
        [isxWin setISXWinMove:NO];
        [isxWin setISXWinScale:YES];
        [isxWin setISXWinBigPicture:NO];
        // 信号类型与通道数据
        isxWin.winSourceType = 0;       // 默认HDMI
        isxWin.winChannelNumber = nWinNum; // 默认一对一
        // 窗口与单元大小设置
        [isxWin setISXWinBasicWinWidth:_appUnitWidth*2];
        [isxWin setISXWinBasicWinHeight:_appUnitHeight*2];
        [isxWin setISXWinCurrentWinWidth:_appUnitWidth*2];
        [isxWin setISXWinCurrentWinHeight:_appUnitHeight*2];
        
        // 窗口数据写入字典
        [dict setObject:[NSString stringWithFormat:@"%f",isxWin.startPoint.x] forKey:kISXWINSTARTX];
        [dict setObject:[NSString stringWithFormat:@"%f",isxWin.startPoint.y] forKey:kISXWINSTARTY];
        [dict setObject:[NSString stringWithFormat:@"%f",isxWin.winSize.width] forKey:kISXWINSIZEW];
        [dict setObject:[NSString stringWithFormat:@"%f",isxWin.winSize.height] forKey:kISXWINSIZEH];
        [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinMove] ? 1:0] forKey:kISXWINMOVE];
        [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinScale] ? 1:0] forKey:kISXWINSCALE];
        [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinBigPicture] ? 1:0] forKey:kISXWINBIGPIC];
        [dict setObject:[NSString stringWithFormat:@"%d",isxWin.winSourceType] forKey:kISXWINSIGNALTYPE];
        [dict setObject:[NSString stringWithFormat:@"%d",isxWin.winChannelNumber] forKey:kISXWINCHANNELNUM];
        [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinBasicWinWidth]] forKey:kISXWINBWIDTH];
        [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinBasicWinHeight]] forKey:kISXWINBHEIGHT];
        [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinCurrentWinWidth]] forKey:kISXWINCWIDTH];
        [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinCurrentWinHeight]] forKey:kISXWINCHEIGHT];
        
        // 写入文件
        [dict writeToFile:appDefaultFileName atomically:YES];
    }
    else
    {
        // 如果文件存在读取文件数据
        isxWin.startPoint = CGPointMake([[dict objectForKey:kISXWINSTARTX] floatValue], [[dict objectForKey:kISXWINSTARTY] floatValue]);
        isxWin.winSize = CGSizeMake([[dict objectForKey:kISXWINSIZEW] floatValue], [[dict objectForKey:kISXWINSIZEH] floatValue]);
        [isxWin setISXWinMove:[[dict objectForKey:kISXWINMOVE] intValue] == 1 ? YES : NO];
        [isxWin setISXWinScale:[[dict objectForKey:kISXWINSCALE] intValue] == 1 ? YES : NO];
        [isxWin setISXWinBigPicture:[[dict objectForKey:kISXWINBIGPIC] intValue] == 1 ? YES : NO];
        isxWin.winSourceType = [[dict objectForKey:kISXWINSIGNALTYPE] intValue];
        isxWin.winChannelNumber = [[dict objectForKey:kISXWINCHANNELNUM] intValue];
        [isxWin setISXWinBasicWinWidth:[[dict objectForKey:kISXWINBWIDTH] intValue]];
        [isxWin setISXWinBasicWinHeight:[[dict objectForKey:kISXWINBHEIGHT] intValue]];
        [isxWin setISXWinCurrentWinWidth:[[dict objectForKey:kISXWINCWIDTH] intValue]];
        [isxWin setISXWinCurrentWinHeight:[[dict objectForKey:kISXWINCHEIGHT] intValue]];
    }
}

// 数据序列化到文件
- (void)saveISXWinDataSource:(id)sender
{
    skyISXWin *isxWin = (skyISXWin *)sender;
    int nWinNum = isxWin.winNumber;
    
    // 一个窗口一个文件 拼接窗口 skyISXWin_X X-nWinNum
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appStandardDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStandard"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appStandardDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appStandardDir stringByAppendingPathComponent:[NSString stringWithFormat:@"skyISXWin_%d",nWinNum]];
    
    // 字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 窗口数据写入字典
    [dict setObject:[NSString stringWithFormat:@"%f",isxWin.startPoint.x] forKey:kISXWINSTARTX];
    [dict setObject:[NSString stringWithFormat:@"%f",isxWin.startPoint.y] forKey:kISXWINSTARTY];
    [dict setObject:[NSString stringWithFormat:@"%f",isxWin.winSize.width] forKey:kISXWINSIZEW];
    [dict setObject:[NSString stringWithFormat:@"%f",isxWin.winSize.height] forKey:kISXWINSIZEH];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinMove] ? 1:0] forKey:kISXWINMOVE];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinScale] ? 1:0] forKey:kISXWINSCALE];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinBigPicture] ? 1:0] forKey:kISXWINBIGPIC];
    [dict setObject:[NSString stringWithFormat:@"%d",isxWin.winSourceType] forKey:kISXWINSIGNALTYPE];
    [dict setObject:[NSString stringWithFormat:@"%d",isxWin.winChannelNumber] forKey:kISXWINCHANNELNUM];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinBasicWinWidth]] forKey:kISXWINBWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinBasicWinHeight]] forKey:kISXWINBHEIGHT];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinCurrentWinWidth]] forKey:kISXWINCWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinCurrentWinHeight]] forKey:kISXWINCHEIGHT];
    
    // 写入文件
    [dict writeToFile:appDefaultFileName atomically:YES];
}

// 窗口的情景数据序列化到文件
- (void)saveISXWinModelDataSource:(id)sender AtIndex:(NSInteger)nIndex
{
    skyISXWin *isxWin = (skyISXWin *)sender;
    NSInteger nWinNum = isxWin.winNumber;
    
    // 创建模式文件夹
    NSString *modelPath = [NSString stringWithFormat:@"ModelDir_%ld",nIndex];
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *modelDirPath = [appDefaultsPath stringByAppendingPathComponent:modelPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:modelDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *savePath = [modelDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"skyISXWin_%ld",nWinNum]];
    
    // 保存窗口数据
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    // 窗口数据写入字典
    [dict setObject:[NSString stringWithFormat:@"%f",isxWin.startPoint.x] forKey:kISXWINSTARTX];
    [dict setObject:[NSString stringWithFormat:@"%f",isxWin.startPoint.y] forKey:kISXWINSTARTY];
    [dict setObject:[NSString stringWithFormat:@"%f",isxWin.winSize.width] forKey:kISXWINSIZEW];
    [dict setObject:[NSString stringWithFormat:@"%f",isxWin.winSize.height] forKey:kISXWINSIZEH];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinMove] ? 1:0] forKey:kISXWINMOVE];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinScale] ? 1:0] forKey:kISXWINSCALE];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinBigPicture] ? 1:0] forKey:kISXWINBIGPIC];
    [dict setObject:[NSString stringWithFormat:@"%d",isxWin.winSourceType] forKey:kISXWINSIGNALTYPE];
    [dict setObject:[NSString stringWithFormat:@"%d",isxWin.winChannelNumber] forKey:kISXWINCHANNELNUM];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinBasicWinWidth]] forKey:kISXWINBWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinBasicWinHeight]] forKey:kISXWINBHEIGHT];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinCurrentWinWidth]] forKey:kISXWINCWIDTH];
    [dict setObject:[NSString stringWithFormat:@"%d",[isxWin getISXWinCurrentWinHeight]] forKey:kISXWINCHEIGHT];
    
    // 将字典数据写入文件
    [dict writeToFile:savePath atomically:YES];
}

// 反序列化窗口情景模式
- (void)loadISXWinModelDataSource:(id)sender AtIndex:(NSInteger)nIndex
{
    skyISXWin *isxWin = (skyISXWin *)sender;
    NSInteger nWinNum = isxWin.winNumber;
    
    // 创建模式文件夹
    NSString *modelPath = [NSString stringWithFormat:@"ModelDir_%ld",nIndex];
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *modelDirPath = [appDefaultsPath stringByAppendingPathComponent:modelPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:modelDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *savePath = [modelDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"skyISXWin_%ld",nWinNum]];
    
    // 字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];
    
    isxWin.startPoint = CGPointMake([[dict objectForKey:kISXWINSTARTX] floatValue], [[dict objectForKey:kISXWINSTARTY] floatValue]);
    isxWin.winSize = CGSizeMake([[dict objectForKey:kISXWINSIZEW] floatValue], [[dict objectForKey:kISXWINSIZEH] floatValue]);
    [isxWin setISXWinMove:[[dict objectForKey:kISXWINMOVE] intValue] == 1 ? YES : NO];
    [isxWin setISXWinScale:[[dict objectForKey:kISXWINSCALE] intValue] == 1 ? YES : NO];
    [isxWin setISXWinBigPicture:[[dict objectForKey:kISXWINBIGPIC] intValue] == 1 ? YES : NO];
    isxWin.winSourceType = [[dict objectForKey:kISXWINSIGNALTYPE] intValue];
    isxWin.winChannelNumber = [[dict objectForKey:kISXWINCHANNELNUM] intValue];
    [isxWin setISXWinBasicWinWidth:[[dict objectForKey:kISXWINBWIDTH] intValue]];
    [isxWin setISXWinBasicWinHeight:[[dict objectForKey:kISXWINBHEIGHT] intValue]];
    [isxWin setISXWinCurrentWinWidth:[[dict objectForKey:kISXWINCWIDTH] intValue]];
    [isxWin setISXWinCurrentWinHeight:[[dict objectForKey:kISXWINCHEIGHT] intValue]];
}

#pragma mark - skyCVBSSignalView DataSource
// 获取矩阵别名
- (NSString *)getCVBSMatrixAliasAtIndex:(int)nIndex
{
    return @"";
}

#pragma mark - skyVGASignalView DataSource
// 获取VGA矩阵输入通道别名
- (NSString *)getVGAMatrixAliasAtIndex:(int)nIndex
{
    return @"";
}

#pragma mark - skyHDMISignalView DataSource
// 获取矩阵别名
- (NSString *)getHDMIMatrixAliasAtIndex:(int)nIndex
{
    return @"";
}

#pragma mark - skyDVISignalView DataSource
// 获取矩阵别名
- (NSString *)getDVIMatrixAliasAtIndex:(int)nIndex
{
    return @"";
}

#pragma mark - skyModelViewController DataSource
// 获取运行截图
- (UIImage *)getModelImageAtIndex:(int)nIndex
{
    return [_appModelSaveImageArray objectAtIndex:nIndex];
}

// 保存情景模式状态
- (void)saveModelDataSource
{
    // 存入文件索引
    NSString *appDefaultsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appStandardDir = [appDefaultsPath stringByAppendingPathComponent:@"AppStatus"];
    [[NSFileManager defaultManager] createDirectoryAtPath:appStandardDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *appDefaultFileName = [appStandardDir stringByAppendingPathComponent:APPMODELSAVEFILE];
    
    [_appModelSaveDic writeToFile:appDefaultFileName atomically:YES];
}

// 确认情景模式是否可用
- (BOOL)isModelCanBeUsedAtIndex:(int)nIndex
{
    NSString *modelKey = [NSString stringWithFormat:@"Model-%d",nIndex+1];
    
    NSInteger nValue = [[_appModelSaveDic objectForKey:modelKey] integerValue];
    
    return (nValue == 1) ? YES : NO;
}

@end
