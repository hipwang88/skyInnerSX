//
//  skyISXWin.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-26.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyISXWin.h"
#import "definitions.h"

#define kBoarderViewSize        -7.5f

static skyResizableAnchorPoint resizableAnchorPointNone = {0.0, 0.0, 0.0, 0.0, 0};
static skyResizableAnchorPoint resizableAnchorPointUpperLeft = {1.0, 1.0, -1.0, 1.0, 1};
static skyResizableAnchorPoint resizableAnchorPointMiddleLeft = {1.0, 0.0, 0.0, 1.0, 8};
static skyResizableAnchorPoint resizableAnchorPointLowerLeft = {1.0, 0.0, 1.0, 1.0, 7};
static skyResizableAnchorPoint resizableAnchorPointUpperMiddle = {0.0, 1.0, -1.0, 0.0, 2};
static skyResizableAnchorPoint resizableAnchorPointUpperRight = {0.0, 1.0, -1.0, -1.0, 3};
static skyResizableAnchorPoint resizableAnchorPointMiddleRight = {0.0, 0.0, 0.0, -1.0, 4};
static skyResizableAnchorPoint resizableAnchorPointLowerRight = {0.0, 0.0, 1.0, -1.0, 5};
static skyResizableAnchorPoint resizableAnchorPointLowerMiddle = {0.0, 0.0, 1.0, 0.0, 6};

@interface skyISXWin()
{
    int         nRows;                      // 拼接规格
    int         nColumns;
    skyResizableAnchorPoint anchor;         // 锚点定位
    
    CGPoint     touchBegin;                 // 触摸点
    CGPoint     touchEnd;
    BOOL        isNotChange;
}

///////////////////// Property ////////////////////////

///////////////////// Methods /////////////////////////
// 变量默认初始
- (void)initDefaults;
// 窗口组件初始化
- (void)initComponents;
// 初始化弹出菜单
- (void)initPopovers;
// 功能扩展按钮
- (void)functionButtonHandle:(id)sender;
// 手势事件函数
- (void)handlePanGestures:(UIPanGestureRecognizer *)paramSender;
// 点击手势事件
- (void)handleTapGestures:(UITapGestureRecognizer *)paramSender;
// 渐进背景绘制
- (void)drawViewBackground:(CGContextRef)context;
// 绘制窗口外框
- (void)drawOutline:(CGContextRef)context;
// 信号类型与通道标签设置
- (void)setSignal:(int)nType andChannel:(int)nChannel;
// 移动视图
- (void)moveSCXWinUsingTouchLocation:(CGPoint)touchPoint;
// 缩放视图
- (void)resizeSCXWinUsingTouchLocation:(CGPoint)touchPoint;
// 确定点击时手指在那个Anchor附近
- (skyResizableAnchorPoint)anchorPointForTouchLocation:(CGPoint)touchPoint;
// 判断是移动还是缩放
- (BOOL)isResizing;
// 获取大小数据
- (NSString *)getWindowSizeStr;

///////////////////// Ends ////////////////////////////

@end

@implementation skyISXWin

@synthesize winNumber = nWinNumber;
@synthesize winSourceType = nSignalType;
@synthesize winChannelNumber = nChannelNumber;
@synthesize startPoint = _startPoint;
@synthesize winSize = _winSize;
@synthesize startCanvas = _startCanvas;
@synthesize limitRect = _limitRect;
@synthesize winNumberLabel = _winNumberLabel;
@synthesize signalLabel = _signalLabel;
@synthesize funcButton = _funcButton;
@synthesize winBoarder = _winBoarder;
@synthesize isxPop = _isxPop;
@synthesize popView = _popView;
@synthesize myDelegate = _myDelegate;
@synthesize myDataSource = _myDataSource;
@synthesize panGesture = _panGesture;
@synthesize tapGesture = _tapGesture;

#pragma mark - Basic Methods
// 窗口初始
- (id)initWithFrame:(CGRect)frame withRow:(int)nRow andColumn:(int)nColumn
{
    self = [super initWithFrame:frame];
    if (self)
    {
        nRows = nRow;
        nColumn = nColumns;
        
        // 变量初始
        [self initDefaults];
        // 组件初始
        [self initComponents];
        // 弹出视图初始
        [self initPopovers];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _winBoarder.frame = CGRectInset(self.bounds, kBoarderViewSize, kBoarderViewSize);
    [_winBoarder setNeedsDisplay];
}

// 自绘
- (void)drawRect:(CGRect)rect
{
    // 创建Quartz上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制背景
    [self drawViewBackground:context];
    // 绘制窗口外框
    [self drawOutline:context];
}

// 渐进背景绘制
- (void)drawViewBackground:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    // 创建起点颜色
    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){17.0f/255.0f, 32.0f/255.0f, 103.0f/255.0f, 192.0f/255.0f});
    
    // 创建终点颜色
    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){89.0f/255.0f, 113.0f/255.0f, 227.0f/255.0f, 192.0f/255.0f});
    
    // 创建颜色数组
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
    
    // 创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        0.0f,       // 对应起点颜色位置
        1.0f        // 对应终点颜色位置
    });
    
    // 释放颜色数组
    CFRelease(colorArray);
    
    // 释放起点和终点颜色
    CGColorRelease(beginColor);
    CGColorRelease(endColor);
    
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(0.0f, 0.0f), CGPointMake(self.bounds.size.width, self.bounds.size.height), 0);
    
    // 释放渐变对象
    CGGradientRelease(gradientRef);
    
    UIGraphicsPopContext();
}

// 绘制窗口外框
- (void)drawOutline:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor);
    
    CGContextSetLineWidth(context, 1);
    
    CGContextAddRect(context, self.bounds);
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

#pragma mark - skyISXWin Private Methods
// 变量默认初始
- (void)initDefaults
{
    // 窗口状态
    bMovable = NO;
    bScalable = NO;
    bBigPicture = NO;
    // 窗口属性
    nWinNumber = 0;
    nSignalType = SIGNAL_CVBS;
    nChannelNumber = 0;
    nBasicWinWidth = nBasicWinHeight = nCurrentWinWidth = nCurrentWinHeight = 0;
    // 窗口范围
    windowRect = CGRectZero;
    // 窗口棋盘
    _startPoint = CGPointZero;
    _winSize = CGSizeZero;
}

// 窗口组件初始化
- (void)initComponents
{
    CGRect bounds = self.bounds;
    
    // init Labels
    // 加入窗口Label
    CGRect winNumRect = CGRectMake(8, 8, bounds.size.width-16, bounds.size.height/7);
    _winNumberLabel = [[UILabel alloc] initWithFrame:winNumRect];
    _winNumberLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:bounds.size.height/7];
    _winNumberLabel.textAlignment = NSTextAlignmentLeft;
    _winNumberLabel.backgroundColor = [UIColor clearColor];
    _winNumberLabel.textColor = [UIColor whiteColor];
    _winNumberLabel.text = [NSString stringWithFormat:@"No.%d",nWinNumber];
    _winNumberLabel.alpha = 1.0;
    _winNumberLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    // 加入信号源Label
    CGRect signalRect = CGRectMake(8, 5*bounds.size.height/6-8, bounds.size.width-16, bounds.size.height/6);
    _signalLabel = [[UILabel alloc] initWithFrame:signalRect];
    _signalLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:bounds.size.height/6];
    _signalLabel.textAlignment = NSTextAlignmentRight;
    _signalLabel.backgroundColor = [UIColor clearColor];
    _signalLabel.textColor = [UIColor whiteColor];
    _signalLabel.text = [NSString stringWithFormat:@"CVBS-%d",nWinNumber];
    _signalLabel.alpha = 1.0;
    _signalLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    
    // init Func Button
    UIImage *image = [UIImage imageNamed:@"scxWin_Btn_Normal.png"];
    _funcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _funcButton.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    _funcButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self.funcButton setBackgroundImage:[UIImage imageNamed:@"scxWin_Btn_Normal"] forState:UIControlStateNormal];
    [self.funcButton setBackgroundImage:[UIImage imageNamed:@"scxWin_Btn_Select"] forState:UIControlStateHighlighted];
    [self.funcButton addTarget:self action:@selector(functionButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    _funcButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    // init Win Boarder
    _winBoarder = [[skyWinBoarder alloc] initWithFrame:CGRectInset(self.bounds, kBoarderViewSize, kBoarderViewSize)];
    _winBoarder.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_winBoarder];
    [_winBoarder setHidden:YES];
    
    // 手势识别器 - 拖动
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    _panGesture.minimumNumberOfTouches = 1;
    _panGesture.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:_panGesture];
    // 手势识别器 - 点击
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestures:)];
    _tapGesture.delegate = self;
    [self addGestureRecognizer:_tapGesture];
    
    // 添加视图
    [self addSubview:_winNumberLabel];
    [self addSubview:_signalLabel];
    [self addSubview:_funcButton];
    
    self.autoresizesSubviews = YES;
}

// 初始化弹出菜单
- (void)initPopovers
{
    // 功能选择主菜单
    _isxPop = [[skyISXWinPopoverVC alloc] initWithStyle:UITableViewStyleGrouped];
    _isxPop.myDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_isxPop];
    _popView = [[UIPopoverController alloc] initWithContentViewController:nav];
    _popView.popoverContentSize = CGSizeMake(320.0f, 450.0f);
}

// 功能扩展按钮
- (void)functionButtonHandle:(id)sender
{
    
}

// 手势事件函数
- (void)handlePanGestures:(UIPanGestureRecognizer *)paramSender
{
    
}

// 点击手势事件
- (void)handleTapGestures:(UITapGestureRecognizer *)paramSender
{
    
}

// 信号类型与通道标签设置
- (void)setSignal:(int)nType andChannel:(int)nChannel
{
    nSignalType = nType;
    nChannelNumber = nChannel;
    
    // 信号源与类型
    switch (nSignalType)
    {
        case SIGNAL_HDMI:// HDMI
            _signalLabel.text = [NSString stringWithFormat:@"HDMI-%d",nChannelNumber];
            break;
        case SIGNAL_DVI:// DVI
            _signalLabel.text = [NSString stringWithFormat:@"DVI-%d",nChannelNumber];
            break;
        case SIGNAL_VGA:// VGA
            _signalLabel.text = [NSString stringWithFormat:@"VGA-%d",nChannelNumber];
            break;
        case SIGNAL_CVBS:// CVBS
            _signalLabel.text = [NSString stringWithFormat:@"CVBS-%d",nChannelNumber];
            break;
    }
}

// 移动视图
- (void)moveSCXWinUsingTouchLocation:(CGPoint)touchPoint
{
    
}

// 缩放视图
- (void)resizeSCXWinUsingTouchLocation:(CGPoint)touchPoint
{
    
}

// 确定点击时手指在那个Anchor附近
- (skyResizableAnchorPoint)anchorPointForTouchLocation:(CGPoint)touchPoint
{
    return resizableAnchorPointLowerLeft;
}

// 判断是移动还是缩放
- (BOOL)isResizing
{
    return true;
}

// 获取大小数据
- (NSString *)getWindowSizeStr
{
    return nil;
}

#pragma mark - skyISXWin Setter & Getter Methods
// 窗口属性setter/getter
- (void)setISXWinMove:(BOOL)bMove
{
    bMovable = bMove;
}

- (BOOL)getISXWinMove
{
    return bMovable;
}

- (void)setISXWinScale:(BOOL)bScale
{
    bScalable = bScale;
}

- (BOOL)getISXWinScale
{
    return bScalable;
}

- (void)setISXWinBigPicture:(BOOL)bBigPic
{
    bBigPicture = bBigPic;
}

- (BOOL)getISXWinBigPicture
{
    return bBigPicture;
}

// 窗口大小setter/getter
- (void)setISXWinBasicWinWidth:(int)nBasicWidth
{
    nBasicWinWidth = nBasicWidth;
}

- (int)getISXWinBasicWinWidth
{
    return nBasicWinWidth;
}

- (void)setISXWinBasicWinHeight:(int)nBasicHeight
{
    nBasicWinHeight = nBasicHeight;
}

- (int)getISXWinBasicWinHeight
{
    return nBasicWinHeight;
}

- (void)setISXWinCurrentWinWidth:(int)nCurrentWidth
{
    nCurrentWinWidth = nCurrentWidth;
}

- (int)getISXWinCurrentWinWidth
{
    return nCurrentWinWidth;
}

- (void)setISXWinCurrentWinHeight:(int)nCurrentHeight
{
    nCurrentWinHeight = nCurrentHeight;
}

- (int)getISXWinCurrentWinHeight
{
    return nCurrentWinHeight;
}

#pragma mark - skyISXWin Public Methods
// 窗口数据初始化
- (void)initializeISXWin:(int)nwinNum
{
    // 设置初值
    nWinNumber = nwinNum;
    
    // 窗口初始化
    [_myDataSource initISXWinDataSource:self];
    
    // 信号源切换界面初始化
    _isxPop.signalView = [[skySignalViewController alloc] initWithStyle:UITableViewStylePlain];
    _isxPop.signalView.myDataSource = [_myDelegate isxWinSignalDataSource];
    _isxPop.signalView.myDelegate = self;
    
    // 更新窗口UI
    [self updateWindowUI];
}

// 窗口UI更新
- (void)updateWindowUI
{
    /********************* 标签值设置 *********************/
    // 窗口编号标签
    _winNumberLabel.text = [NSString stringWithFormat:@"No.%d",nWinNumber];
    
    // 信号源与类型
    [self setSignal:nSignalType andChannel:nChannelNumber];
    
    // 设置窗口位置
    [self splitWinStartX:_startPoint.x StartY:_startPoint.y HCount:_winSize.width VCount:_winSize.height];
}

// 切换矩阵
- (void)switchSignal:(int)nType toChannel:(int)nChannel
{
    
}

// 窗口大小改变
- (void)splitWinStartX:(int)startX StartY:(int)startY HCount:(int)nHcount VCount:(int)nVCount
{
    
}

// CVBS新建
- (void)newWithCVBS
{
    
}

// VGA新建
- (void)newWithVGA
{
    
}

// HDMI新建
- (void)newWithHDMI
{
    
}

// DVI新建
- (void)newWithDVI
{
    
}

// 保存状态到文件
- (void)saveISXWinToFile
{
    
}

// 显示外框
- (void)showBoarderView
{
    [_winBoarder setHidden:NO];
    
    // 状态置换
    bMovable = NO;
    bScalable = YES;
}

// 隐藏外框
- (void)hideBoarderView
{
    [_winBoarder setHidden:YES];
    
    // 状态置换
    bMovable = NO;
    bScalable = NO;
}

// 结束缩放后重新刷新窗口 --- 让窗口满屏
- (void)reCaculateSCXWinToFullScreen
{
    
}

// 窗口单屏状态
- (void)setISXWinToSingleStatus
{
    
}

// 窗口全屏状态
- (void)setISXWinToFullStatus
{
    
}

// 保存当前窗口的情景模式
- (void)saveISXWinModelStatusAtIndex:(int)nIndex
{
    
}

// 加载窗口情景模式
- (void)loadISXWinModelStatusAtIndex:(int)nIndex
{
    
}

@end
