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

@end
