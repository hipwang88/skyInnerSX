//
//  skyInner6M48TVSDK.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-26.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyInner6M48TVSDK.h"
#import "AsyncSocket.h"

// Private
@interface skyInner6M48TVSDK()<AsyncSocketDelegate>
{
    Byte m_nSendCmd[32];                    // 发送数组
    Byte m_nReceiveCmd[32];                 // 接收数组
    BOOL m_bConnection;                     // 连接状态
    BOOL m_bConnectedBefore;                // 以前是否连接
}

///////////////////// Property /////////////////////////
@property (nonatomic, strong) AsyncSocket *tcpSocket;               // Socket 对象
@property (nonatomic, strong) NSString *serviceAddress;             // 服务器地址
@property (nonatomic, assign) int nPort;                            // 服务器端口

///////////////////// Methods //////////////////////////
// 连接判断
- (BOOL)isConnected;
// 协议发送
- (void)sendCmd:(int)nLength;
// 协议接收
- (void)recevieCmd:(int)nLength;
// 获取发送码字符串
- (NSString *)sendStringWithLog:(NSString *)stringLog andByteCount:(int)nCount;

///////////////////// Ends /////////////////////////////

@end

@implementation skyInner6M48TVSDK

@synthesize tcpSocket = _tcpSocket;
@synthesize serviceAddress = _serviceAddress;
@synthesize nPort = _nPort;

#pragma mark - Private Methods
// 连接判断
- (BOOL)isConnected
{
    return m_bConnection;
}

// 协议发送
- (void)sendCmd:(int)nLength
{
    NSData *sendData;
    // 在连接可用情况下发送指令
    if ([self isConnected])
    {
        sendData = [[NSData alloc] initWithBytes:m_nSendCmd length:nLength];
        // 数据发送
        [_tcpSocket writeData:sendData withTimeout:-1 tag:0];
        // 命令延迟
        usleep(SKY_SEND_DELAY);
    }
    else
        LOG_MESSAGE(@"TCP Service can't reach");
}

// 协议接收
- (void)recevieCmd:(int)nLength
{
    NSData *recevieData;
    // 在连接情况下才能读取
    if ([self isConnected])
    {
        [_tcpSocket readDataToData:recevieData withTimeout:-1 tag:0];
        [recevieData getBytes:m_nReceiveCmd length:nLength];
    }
}

// 获取发送码字符串
- (NSString *)sendStringWithLog:(NSString *)stringLog andByteCount:(int)nCount
{
    NSString *stringResult;
    NSData *sendDatas = [[NSData alloc] initWithBytes:m_nSendCmd length:nCount];
    
    stringResult = [NSString stringWithFormat:@"6M48内置拼接 开放协议->>>[%@ : %@]",stringLog,sendDatas];
    
    return stringResult;
}

#pragma mark - Public Methods
// 初始化开放协议SDK
- (id)initOpenSCXProtocol
{
    self = [super init];
    
    if (self)
    {
        // TCP Socket 对象初始
        _tcpSocket = [[AsyncSocket alloc] initWithDelegate:self];
        // 发送与接收数据初始化
        memset(m_nSendCmd, 0, 32);
        memset(m_nReceiveCmd, 0, 32);
        // 连接状态
        m_bConnection = NO;
        m_bConnectedBefore = NO;
    }
    
    return self;
}

// 连接TCP服务器
- (BOOL)connectTCPService:(NSString *)hostAddress andPort:(int)nPortNum
{
    NSError *error;
    BOOL isConnected = NO;
    m_bConnectedBefore = NO;
    
    // 在没有进入连接时尝试连接
    if (!m_bConnection)
    {
        isConnected = [_tcpSocket connectToHost:hostAddress onPort:nPortNum error:&error];
        
        // 连接情况判断
        if (!isConnected)
        {
            NSLog(@"TCP Connected error = %@",error);
            m_bConnection = NO;
        }
        else
        {
            // 变量赋值
            m_bConnection = YES;
            m_bConnectedBefore = YES;
            _serviceAddress = hostAddress;
            _nPort = nPortNum;
            // 设置运行循环模式
            [_tcpSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            
            LOG_MESSAGE([NSString stringWithFormat:@"Connect to %@ onPort %d Successful!",hostAddress,nPortNum],nil);
        }
    }
    return m_bConnection;
}

// 端口TCP服务器
- (void)disconnectWithTCPService
{
    m_bConnection = NO;
    m_bConnectedBefore = NO;
    [_tcpSocket disconnect];
    LOG_MESSAGE(@"Close Socket Connect!");
}

// 服务器重连
- (void)reConnectToService
{
    NSError *error;
    BOOL isConnected = NO;
    
    // 在没有进入连接时尝试连接
    if (m_bConnectedBefore)
    {
        isConnected = [_tcpSocket connectToHost:_serviceAddress onPort:_nPort error:&error];
        
        // 连接情况判断
        if (!isConnected)
        {
            NSLog(@"TCP Connected error = %@",error);
            m_bConnection = NO;
        }
        else
        {
            // 变量赋值
            m_bConnection = YES;
            // 设置运行循环模式
            [_tcpSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            
            LOG_MESSAGE([NSString stringWithFormat:@"Reconnect to %@ onPort %d Successful!",_serviceAddress,_nPort],nil);
        }
    }
}

// 服务器进入后台
- (void)serviceEnterBackground
{
    m_bConnection = NO;
    [_tcpSocket disconnect];
    LOG_MESSAGE(@"Socket Connect Enter Background");
}

#pragma mark - Protocol
// 1.显示编号
- (void)innerSXShowNumber
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x94;
    m_nSendCmd[2] = 0x06;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"显示编号" andByteCount:8],nil);

}

// 2.隐藏编号
- (void)innerSXHideNumber
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x94;
    m_nSendCmd[2] = 0x07;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"隐藏编号" andByteCount:8],nil);
}

// 3.屏幕开机
- (void)innerSXScreenOn
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x3F;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"屏幕开启" andByteCount:8],nil);
}

// 4.屏幕关机
- (void)innerSXScreenOff
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x40;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"屏幕关闭" andByteCount:8],nil);
}

// 5.屏幕全选
- (void)innerSXSelectAll
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x1B;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"选中所有单元" andByteCount:8],nil);
}

// 6.屏幕全不选
- (void)innerSXSelectNone
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x1C;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"取消选中所有单元" andByteCount:8],nil);
}

// 7.选中一个单元
- (void)innerSXSelectOneUnit:(int)nIndex
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x19;
    m_nSendCmd[3] = nIndex;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"选中单元%d",nIndex] andByteCount:8],nil);
}

// 8.取消某个单元选中
- (void)innerSXUnSelectOneUnit:(int)nIndex
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x1A;
    m_nSendCmd[3] = nIndex;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"取消选中单元%d",nIndex] andByteCount:8],nil);
}

// 9.位置自动调整
- (void)innerSXAdjustPosition
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x20;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"位置自动调整" andByteCount:8],nil);
}

// 10.白平衡自动调整
- (void)innerSXAdjustWB
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x21;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"白平衡自动调整" andByteCount:8],nil);
}

// 11.亮度增大
- (void)innerSXBrightnessIncrease
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x10;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"亮度增加" andByteCount:8],nil);
}

// 12.亮度减小
- (void)innerSXBrightnessDecrease
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x11;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"亮度减少" andByteCount:8],nil);
}

// 13.亮度复位
- (void)innerSXBrightnessReset
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x48;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"亮度复位" andByteCount:8],nil);
}

// 14.对比度增大
- (void)innerSXContrastIncrease
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x12;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"对比度增加" andByteCount:8],nil);
}

// 15.对比度减小
- (void)innerSXContrastDecrease
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x13;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"对比度减小" andByteCount:8],nil);
}

// 16.对比度复位
- (void)innerSXContrastReset
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x74;
    m_nSendCmd[2] = 0x49;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"对比度复位" andByteCount:8],nil);
}

// 17.大画面拼接 -- 合成
- (void)innerSXSpliceScreen:(int)nWin StartAt:(int)nStartPanel VCountNum:(int)nVCount HCountNum:(int)nHCount
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0xD6;
    m_nSendCmd[2] = 0x10;
    m_nSendCmd[3] = nStartPanel;
    m_nSendCmd[4] = nVCount;
    m_nSendCmd[5] = nHCount;
    m_nSendCmd[6] = nWin;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"合成大画面 nWin=%d nStartPanel=%d nVCount=%d nHCount=%d",nWin,nStartPanel,nVCount,nHCount] andByteCount:8],nil);
}

// 17.大画面拼接 -- 信号切换
- (void)innerSXSwitchBigScreen:(int)nWin toSrcType:(int)nType atSrcPath:(int)nPath
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    switch (nType)
    {
        case SIGNAL_CVBS:
            m_nSendCmd[1] = 0x32;
            break;
            
        case SIGNAL_VGA:
            m_nSendCmd[1] = 0x31;
            break;
            
        case SIGNAL_HDMI:
        case SIGNAL_DVI:
            m_nSendCmd[1] = 0x33;
            break;
    }
    m_nSendCmd[2] = nPath;
    m_nSendCmd[3] = nWin;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"大画面信号切换 nWin=%d nType=%d nPath=%d",nWin,nType,nPath] andByteCount:8],nil);
}

// 18.大画面分解 -- 拆分
- (void)innerSXSplitBigScreen:(int)nWin StartAt:(int)nStartPanel VCountNum:(int)nVCount HCountNum:(int)nHCount
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0xD6;
    m_nSendCmd[2] = 0x11;
    m_nSendCmd[3] = nStartPanel;
    m_nSendCmd[4] = nVCount;
    m_nSendCmd[5] = nHCount;
    m_nSendCmd[6] = nWin;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"拆分大画面 nWin=%d nStartPanel=%d nVCount=%d nHCount=%d",nWin,nStartPanel,nVCount,nHCount] andByteCount:8],nil);
}

// 18.大画面分解 -- 状态恢复
- (void)innerSXResolveScreen:(int)nWin StartAt:(int)nStartPanel VCountNum:(int)nVCount HCountNum:(int)nHCount
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0xD6;
    m_nSendCmd[2] = 0x12;
    m_nSendCmd[3] = nStartPanel;
    m_nSendCmd[4] = nVCount;
    m_nSendCmd[5] = nHCount;
    m_nSendCmd[6] = nWin;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"拆分大画面后状态恢复 nWin=%d nStartPanel=%d nVCount=%d nHCount=%d",nWin,nStartPanel,nVCount,nHCount] andByteCount:8],nil);
}

// 19.分解所有大画面
- (void)innerSXSplitAllBigScreens
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x94;
    m_nSendCmd[2] = 0x37;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"拆分所有大画面" andByteCount:8],nil);
}

// 20.单画面信号切换
- (void)innerSXSingleScreen:(int)nWin SwitchSrcType:(int)nType toSrcPath:(int)nPath
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x81;
    switch (nType)
    {
        case SIGNAL_CVBS:
            m_nSendCmd[1] = 0x32;
            break;
            
        case SIGNAL_VGA:
            m_nSendCmd[1] = 0x31;
            break;
            
        case SIGNAL_HDMI:
        case SIGNAL_DVI:
            m_nSendCmd[1] = 0x33;
            break;
    }
    m_nSendCmd[2] = nPath;
    m_nSendCmd[3] = nWin;
    m_nSendCmd[4] = 0x02;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"单画面信号切换 nWin=%d nType=%d nPath=%d",nWin,nType,nPath] andByteCount:8],nil);
}

// 21.大画面信号切换
- (void)innerSXBigScreen:(int)nWin SwitchSrcType:(int)nType toSrcPath:(int)nPath
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x81;
    switch (nType)
    {
        case SIGNAL_CVBS:
            m_nSendCmd[1] = 0x32;
            break;
            
        case SIGNAL_VGA:
            m_nSendCmd[1] = 0x31;
            break;
            
        case SIGNAL_HDMI:
        case SIGNAL_DVI:
            m_nSendCmd[1] = 0x33;
            break;
    }
    m_nSendCmd[2] = nPath;
    m_nSendCmd[3] = nWin;
    m_nSendCmd[4] = 0x01;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"大画面信号切换 nWin=%d nType=%d nPath=%d",nWin,nType,nPath] andByteCount:8],nil);

}

// 22.情景模式保存
- (void)innerSXModelSave:(int)nIndex
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x02;
    m_nSendCmd[2] = nIndex;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"情景模式%d保存",nIndex] andByteCount:8],nil);
}

// 23.情景模式加载 -- 拆分大画面
- (void)innerSXLoadModelSplit
{
    [self innerSXSplitAllBigScreens];
}

// 23.情景模式加载 -- 加载大画面参数
- (void)innerSXLoadModelParameter:(int)nIndex
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x94;
    m_nSendCmd[2] = 0x5E;
    m_nSendCmd[3] = nIndex;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"加载情景模式%d的参数",nIndex] andByteCount:8],nil);
}

// 23.情景模式加载 -- 加载信号、通道、单元状态
- (void)innerSXLoadModel:(int)nIndex
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x01;
    m_nSendCmd[2] = nIndex;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"加载情景模式%d的屏幕和通道信息",nIndex] andByteCount:8],nil);
}

// 24.情景模式新建 -- CVBS新建
- (void)innerSXModelNewWithCVBS
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x03;
    m_nSendCmd[2] = 0x32;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"CVBS情景新建" andByteCount:8],nil);
}

// 24.情景模式新建 -- VGA新建
- (void)innerSXModelNewWithVGA
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x03;
    m_nSendCmd[2] = 0x31;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"VGA情景新建" andByteCount:8],nil);
}

// 24.情景模式新建 -- HDMI新建
- (void)innerSXModelNewWithHDMI
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0x03;
    m_nSendCmd[2] = 0x33;
    m_nSendCmd[3] = 0xFF;
    m_nSendCmd[4] = 0xFF;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"HDMI情景新建" andByteCount:8],nil);
}

// 25.拼接规格设定
- (void)innerSXSetSpliceRow:(int)nRow andColumn:(int)nColumn
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x85;
    m_nSendCmd[1] = 0xD5;
    m_nSendCmd[2] = 0x24;
    m_nSendCmd[3] = nRow;
    m_nSendCmd[4] = nColumn;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:[NSString stringWithFormat:@"写入拼接规格 nRow=%d nColumn=%d",nRow,nColumn] andByteCount:8],nil);
}

// 26.菜单按键
- (void)innerSXMenuClick
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x89;
    m_nSendCmd[2] = 0x73;
    m_nSendCmd[3] = 0x23;
    m_nSendCmd[4] = 0x01;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"菜单按钮按下" andByteCount:8],nil);
}

// 27.菜单上按键
- (void)innerSXUpClick
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x89;
    m_nSendCmd[2] = 0x63;
    m_nSendCmd[3] = 0x33;
    m_nSendCmd[4] = 0x01;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"菜单上按下" andByteCount:8],nil);
}

// 28.菜单下按键
- (void)innerSXDownClick
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x89;
    m_nSendCmd[2] = 0x83;
    m_nSendCmd[3] = 0x13;
    m_nSendCmd[4] = 0x01;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"菜单下按下" andByteCount:8],nil);
}

// 29.菜单左按键
- (void)innerSXLeftClick
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x89;
    m_nSendCmd[2] = 0x72;
    m_nSendCmd[3] = 0x24;
    m_nSendCmd[4] = 0x01;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"菜单左按下" andByteCount:8],nil);
}

// 30.菜单右按键
- (void)innerSXRightClick
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x89;
    m_nSendCmd[2] = 0x74;
    m_nSendCmd[3] = 0x22;
    m_nSendCmd[4] = 0x01;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"菜单右按下" andByteCount:8],nil);
}

// 31.菜单屏显按键
- (void)innerSXPanelDisplayClick
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x89;
    m_nSendCmd[2] = 0xA1;
    m_nSendCmd[3] = 0xF5;
    m_nSendCmd[4] = 0x01;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"菜单屏显按下" andByteCount:8],nil);
}

// 32.菜单信号按键
- (void)innerSXSignalClick
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x89;
    m_nSendCmd[2] = 0x75;
    m_nSendCmd[3] = 0x21;
    m_nSendCmd[4] = 0x01;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"菜单信号按下" andByteCount:8],nil);
}

// 33.菜单确认按键
- (void)innerSXConfirmClick
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x89;
    m_nSendCmd[2] = 0x96;
    m_nSendCmd[3] = 0x33;
    m_nSendCmd[4] = 0x01;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"菜单确认按下" andByteCount:8],nil);
}

// 34.菜单退出按键
- (void)innerSXQuitClick
{
    // 协议命令
    memset(m_nSendCmd, 0, 8);
    m_nSendCmd[0] = 0x80;
    m_nSendCmd[1] = 0x89;
    m_nSendCmd[2] = 0xB8;
    m_nSendCmd[3] = 0x33;
    m_nSendCmd[4] = 0x01;
    m_nSendCmd[5] = 0xFF;
    m_nSendCmd[6] = 0xFF;
    m_nSendCmd[7] = 0xFF;
    // 协议发送
    [self sendCmd:8];
    
    // 发送信息
    LOG_MESSAGE([self sendStringWithLog:@"菜单退出按下" andByteCount:8],nil);
}

#pragma mark - AsyncSocket Delegate
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [_tcpSocket readDataWithTimeout:100 tag:0];
}

@end
