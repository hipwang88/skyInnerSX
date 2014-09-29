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
- (void)moveISXWinUsingTouchLocation:(CGPoint)touchPoint;
// 缩放视图
- (void)resizeISXWinUsingTouchLocation:(CGPoint)touchPoint;
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
        nColumns = nColumn;
        
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
    // 代理类调用 --- 窗口进入操作状态
    [_myDelegate isxWinBeginEditing:self];
    
    // 窗体菜单视图弹出
    [_popView presentPopoverFromRect:_funcButton.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

// 手势事件函数
- (void)handlePanGestures:(UIPanGestureRecognizer *)paramSender
{
    CGPoint touchPoint = [paramSender locationInView:self];
    
    // 在可编辑状态
    if (![_winBoarder isHidden])
    {
        // 判断状态
        switch (paramSender.state)
        {
            case UIGestureRecognizerStateBegan:         // 刚开始进入 -- 开始判断是移动窗口还是缩放窗口
                anchor = [self anchorPointForTouchLocation:touchPoint]; // 判断方位
                touchBegin = touchPoint;                                // 记录开始点
                if ([self isResizing])
                {
                    touchBegin = [paramSender locationInView:self.superview];
                }
                break;
                
            case UIGestureRecognizerStateChanged:       // 拖动中
                if ([self isResizing])  // 缩放状态
                {
                    // 大画面情况下屏蔽缩放功能
                    if (!bBigPicture)
                    {
                        touchPoint = [paramSender locationInView:self.superview];
                        [self resizeISXWinUsingTouchLocation:touchPoint];
                    }
                }
                else                    // 移动状态
                {
                    [self moveISXWinUsingTouchLocation:touchPoint];
                }
                break;
                
            case UIGestureRecognizerStateEnded:         // 结束拖动
            case UIGestureRecognizerStateFailed:
                // 直通满屏处理
                [self reCaculateISXWinToFullScreen];
                // 拼接协议发送
                if (!isNotChange)
                    [_myDelegate isxWinSpliceScreen:self];
                break;
                
            default:
                NSLog(@"Others");
                break;
        }
    }
}

// 点击手势事件
- (void)handleTapGestures:(UITapGestureRecognizer *)paramSender
{
    [_myDelegate isxWinBeginEditing:self];
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

// 两点之间距离
static CGFloat skyDistanceWithTwoPoints(CGPoint point1, CGPoint point2)
{
    CGFloat dx = point1.x - point2.x;
    CGFloat dy = point1.y - point2.y;
    return sqrt(dx*dx + dy*dy);
}

// 移动视图
- (void)moveISXWinUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newPoint = CGPointMake(self.center.x + touchPoint.x - touchBegin.x, self.center.y + touchPoint.y - touchBegin.y);
    
    // 移动限制
    if (bMovable)
    {
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        
        if (newPoint.x > _limitRect.size.width+_limitRect.origin.x  - midPointX)
            newPoint.x = _limitRect.size.width+_limitRect.origin.x - midPointX;
        else if (newPoint.x < _limitRect.origin.x + midPointX)
            newPoint.x = _limitRect.origin.x + midPointX;
        
        CGFloat midPointY = CGRectGetMidY(self.bounds);
        
        if (newPoint.y > _limitRect.size.height+_limitRect.origin.y - midPointY)
            newPoint.y = _limitRect.size.height+_limitRect.origin.y - midPointY;
        else if (newPoint.y < _limitRect.origin.y + midPointY)
            newPoint.y = _limitRect.origin.y + midPointY;
        
        self.center = newPoint;
    }
}

// 缩放视图
- (void)resizeISXWinUsingTouchLocation:(CGPoint)touchPoint
{
    // 限制缩放
    if (bScalable)
    {
        // 处理视图移动细节
        CGFloat deltaW = anchor.adjustW * (touchBegin.x - touchPoint.x);
        CGFloat deltaX = anchor.adjustX * (-1.0 * deltaW);
        CGFloat deltaH = anchor.adjustH * (touchPoint.y - touchBegin.y);
        CGFloat deltaY = anchor.adjustY * (-1.0 * deltaH);
        
        // 计算出View的四个新值
        CGFloat newX = self.frame.origin.x + deltaX;
        CGFloat newY = self.frame.origin.y + deltaY;
        CGFloat newWidth = self.frame.size.width + deltaW;
        CGFloat newHeight = self.frame.size.height + deltaH;
        
        // 限制可拉伸最小值
        if (newWidth < 3*nBasicWinWidth/4) {
            newWidth = self.frame.size.width;
            newX = self.frame.origin.x;
        }
        if (newHeight < 3*nBasicWinHeight/4) {
            newHeight = self.frame.size.height;
            newY = self.frame.origin.y;
        }
        
        // 处理视图的移动
        if (newX < self.limitRect.origin.x)
        {
            deltaW = self.frame.origin.x - self.limitRect.origin.x;
            newWidth = self.frame.size.width + deltaW;
            newX = self.limitRect.origin.x;
        }
        if (newX + newWidth > self.limitRect.origin.x + self.limitRect.size.width)
        {
            newWidth = self.limitRect.size.width + self.limitRect.origin.x - newX;
        }
        if (newY < self.limitRect.origin.y)
        {
            deltaH = self.frame.origin.y - self.limitRect.origin.y;
            newHeight = self.frame.size.height + deltaH;
            newY = self.limitRect.origin.y;
        }
        if (newY + newHeight > self.limitRect.origin.y + self.limitRect.size.height)
        {
            newHeight = self.limitRect.size.height+self.limitRect.origin.y - newY;
        }
        
        // 大画面移入状态判断
        CGRect rectFrame = CGRectMake(newX, newY, newWidth, newHeight);
        if (![_myDelegate isISXWinCanReachBigPicture:rectFrame])
        {
            // 重新绘制视图
            self.frame = CGRectMake(newX, newY, newWidth, newHeight);
            touchBegin = touchPoint;
        }
    }
}

// 确定点击时手指在那个Anchor附近
- (skyResizableAnchorPoint)anchorPointForTouchLocation:(CGPoint)touchPoint
{
    // 制作位置与锚点对
    skyPointAndResizableAnchorPoint upperLeft = {CGPointMake(0.0, 0.0), resizableAnchorPointUpperLeft};
    skyPointAndResizableAnchorPoint upperMiddle = {CGPointMake(self.bounds.size.width/2, 0.0), resizableAnchorPointUpperMiddle};
    skyPointAndResizableAnchorPoint upperRight = {CGPointMake(self.bounds.size.width, 0.0), resizableAnchorPointUpperRight};
    skyPointAndResizableAnchorPoint middleLeft = {CGPointMake(0, self.bounds.size.height/2), resizableAnchorPointMiddleLeft};
    skyPointAndResizableAnchorPoint middleRight = {CGPointMake(self.bounds.size.width, self.bounds.size.height/2), resizableAnchorPointMiddleRight};
    skyPointAndResizableAnchorPoint lowerLeft = {CGPointMake(0, self.bounds.size.height), resizableAnchorPointLowerLeft};
    skyPointAndResizableAnchorPoint lowerMiddle = {CGPointMake(self.bounds.size.width/2, self.bounds.size.height), resizableAnchorPointLowerMiddle};
    skyPointAndResizableAnchorPoint lowerRight = {CGPointMake(self.bounds.size.width, self.bounds.size.height), resizableAnchorPointLowerRight};
    skyPointAndResizableAnchorPoint center = {CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2), resizableAnchorPointNone};
    
    // 计算点击位置与锚点最短距离点
    skyPointAndResizableAnchorPoint points[9] = {upperLeft, upperMiddle, upperRight, middleLeft, middleRight, lowerLeft, lowerMiddle, lowerRight, center};
    
    CGFloat smallestDistance = MAXFLOAT;
    skyPointAndResizableAnchorPoint closestPoint = center;
    for (int i = 0; i < 9; i++)
    {
        CGFloat distance = skyDistanceWithTwoPoints(touchPoint, points[i].point);
        if (distance < smallestDistance)
        {
            smallestDistance = distance;
            closestPoint = points[i];
        }
    }
    
    return closestPoint.anchor;
}

// 判断是移动还是缩放
- (BOOL)isResizing
{
    return (anchor.adjustX || anchor.adjustY || anchor.adjustW || anchor.adjustH);
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
    _isxPop.cvbsSignalView = [[skyCVBSSignalView alloc] initWithStyle:UITableViewStylePlain];
    _isxPop.cvbsSignalView.myDataSource = [_myDelegate isxWinCVBSSignalDataSource];
    _isxPop.cvbsSignalView.myDelegate = self;
    
    _isxPop.vgaSignalView = [[skyVGASignalView alloc] initWithStyle:UITableViewStylePlain];
    _isxPop.vgaSignalView.myDataSource = [_myDelegate isxWinVGASignalDataSource];
    _isxPop.vgaSignalView.myDelegate = self;
    
    _isxPop.hdmiSignalView = [[skyHDMISignalView alloc] initWithStyle:UITableViewStylePlain];
    _isxPop.hdmiSignalView.myDataSource = [_myDelegate isxWinHDMISignalDataSource];
    _isxPop.hdmiSignalView.myDelegate = self;
    
    _isxPop.dviSignalView = [[skyDVISignalView alloc] initWithStyle:UITableViewStylePlain];
    _isxPop.dviSignalView.myDataSource = [_myDelegate isxWinDVISignalDataSource];
    _isxPop.dviSignalView.myDelegate = self;
    
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
    // 设置界面信号
    [self setSignal:nType andChannel:nChannel];
    
    // 代理调用
    [_myDelegate isxWin:self Signal:nType SwitchTo:nChannel];
}

// 窗口大小改变
- (void)splitWinStartX:(int)startX StartY:(int)startY HCount:(int)nHcount VCount:(int)nVCount
{
    _startPoint.x = startX;
    _startPoint.y = startY;
    _winSize.width = nHcount;
    _winSize.height = nVCount;
    
    CGRect frameRect;
    frameRect.origin.x = _startCanvas.x + _startPoint.x * nBasicWinWidth;
    frameRect.origin.y = _startCanvas.y + _startPoint.y * nBasicWinHeight;
    frameRect.size.width = _winSize.width * nBasicWinWidth;
    frameRect.size.height = _winSize.height * nBasicWinHeight;
    [self setFrame:frameRect];
    
    // 判断大画面
    if ((_winSize.width == 1) && (_winSize.height == 1))
    {
        bBigPicture = NO;
    }
    else
    {
        bBigPicture = YES;
    }
    
    // 更新大画面状态数组
    [_myDelegate updateBigPicStatusWithStart:_startPoint andSize:_winSize withWinNum:nWinNumber];
}

// CVBS新建
- (void)newWithCVBS
{
    // 信号设置
    [self setSignal:SIGNAL_CVBS andChannel:nWinNumber];
    
    // 窗口回到单屏状态
    [self setISXWinToNormalStatus];
    [self splitWinStartX:(nWinNumber-1)%nColumns StartY:(nWinNumber-1)/nColumns HCount:1 VCount:1];
}

// VGA新建
- (void)newWithVGA
{
    // 信号设置
    [self setSignal:SIGNAL_VGA andChannel:nWinNumber];
    
    // 窗口回到单屏状态
    [self setISXWinToNormalStatus];
    [self splitWinStartX:(nWinNumber-1)%nColumns StartY:(nWinNumber-1)/nColumns HCount:1 VCount:1];
}

// HDMI新建
- (void)newWithHDMI
{
    // 信号设置
    [self setSignal:SIGNAL_HDMI andChannel:nWinNumber];
    
    // 窗口回到单屏状态
    [self setISXWinToNormalStatus];
    [self splitWinStartX:(nWinNumber-1)%nColumns StartY:(nWinNumber-1)/nColumns HCount:1 VCount:1];
}

// DVI新建
- (void)newWithDVI
{
    // 信号设置
    [self setSignal:SIGNAL_DVI andChannel:nWinNumber];
    
    // 窗口回到单屏状态
    [self setISXWinToNormalStatus];
    [self splitWinStartX:(nWinNumber-1)%nColumns StartY:(nWinNumber-1)/nColumns HCount:1 VCount:1];
}

// 保存状态到文件
- (void)saveISXWinToFile
{
    [_myDataSource saveISXWinDataSource:self];
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
- (void)reCaculateISXWinToFullScreen
{
    int startX = 0, startY = 0, HCount = 0, VCount = 0;
    
    // 根据八个方位计算棋盘值
    switch (anchor.direction) {
        case 0: // 正中
            startX = _startPoint.x;
            startY = _startPoint.y;
            HCount = _winSize.width;
            VCount = _winSize.height;
            break;
            
        case 1: // 左上
        case 2: // 上
        case 8: // 左
            // 棋盘值计算
            startX = (int)((self.frame.origin.x-_startCanvas.x) / nBasicWinWidth);
            startY = (int)((self.frame.origin.y-_startCanvas.y) / nBasicWinHeight);
            HCount = (int)((self.frame.origin.x + self.frame.size.width - _startCanvas.x) / nBasicWinWidth + 0.9f) - startX;
            VCount = (int)((self.frame.origin.y + self.frame.size.height - _startCanvas.y) / nBasicWinHeight +0.9f) - startY;
            if (HCount == 0) HCount = 1;
            if (VCount == 0) VCount = 1;
            break;
            
        case 3: // 右上
        case 4: // 右
            startX = _startPoint.x;
            startY = (int)((self.frame.origin.y-_startCanvas.y) / nBasicWinHeight);
            HCount = (int)((self.frame.origin.x + self.frame.size.width - _startCanvas.x) / nBasicWinWidth + 0.9f) - startX;
            VCount = (self.frame.origin.y + self.frame.size.height - _startCanvas.y) / nBasicWinHeight - startY;
            break;
            
        case 5: // 右下
        case 6: // 下
            startX = _startPoint.x;
            startY = _startPoint.y;
            HCount = (int)(self.frame.size.width / nBasicWinWidth + 0.9f);
            VCount = (int)(self.frame.size.height / nBasicWinHeight + 0.9f);
            if (VCount == 0) VCount = 1;
            if (HCount == 0) HCount = 1;
            break;
            
        case 7: // 左下
            startX = (int)((self.frame.origin.x-_startCanvas.x) / nBasicWinWidth);
            startY = _startPoint.y;
            HCount = (self.frame.origin.x + self.frame.size.width - _startCanvas.x) / nBasicWinWidth - startX;
            VCount = (int)((self.frame.origin.y + self.frame.size.height - _startCanvas.y) / nBasicWinHeight + 0.9f) - startY;
            if (VCount == 0) VCount = 1;
            if (HCount == 0) HCount = 1;
            break;
    }
    
    // 判断是否改变位置或大小
    if ((startX == (int)_startPoint.x) && (startY == (int)_startPoint.y)
        && (HCount == (int)_winSize.width) && (VCount == (int)_winSize.height))
        isNotChange = YES;
    else
        isNotChange = NO;
    
    // 大画面情况下屏蔽窗口更新
    if (!bBigPicture)
    {
        // 更新窗口位置
        [self splitWinStartX:startX StartY:startY HCount:HCount VCount:VCount];
    }
    
    [self updateWindowUI];
}

// 窗口单屏状态
- (void)setISXWinToSingleStatus
{
    CGPoint point = CGPointMake((nWinNumber-1) % nColumns, (nWinNumber-1) / nColumns);
    CGSize size = CGSizeMake(1, 1);
    
    // 设置窗口为普通模式
    [self setISXWinToNormalStatus];
    
    // 设置单屏显示
    [self splitWinStartX:point.x StartY:point.y HCount:size.width VCount:size.height];
}

// 窗口全屏状态
- (void)setISXWinToFullStatus
{
    CGPoint point = CGPointMake(0, 0);
    CGSize size = CGSizeMake(nColumns, nRows);
    
    // 设置窗口满屏状态
    [self splitWinStartX:point.x StartY:point.y HCount:size.width VCount:size.height];
}

// 窗口普通状态
- (void)setISXWinToNormalStatus
{
    [_winNumberLabel setHidden:NO];
    [_signalLabel setTextColor:[UIColor whiteColor]];
    
    [_isxPop.tableView reloadData];
}

// 保存当前窗口的情景模式
- (void)saveISXWinModelStatusAtIndex:(int)nIndex
{
    [_myDataSource saveISXWinModelDataSource:self AtIndex:nIndex];
}

// 加载窗口情景模式
- (void)loadISXWinModelStatusAtIndex:(int)nIndex
{
    // 反序列化
    [_myDataSource loadISXWinModelDataSource:self AtIndex:nIndex];
    
    // 信号源切换界面初始化
    _isxPop.cvbsSignalView = [[skyCVBSSignalView alloc] initWithStyle:UITableViewStylePlain];
    _isxPop.cvbsSignalView.myDataSource = [_myDelegate isxWinCVBSSignalDataSource];
    _isxPop.cvbsSignalView.myDelegate = self;
    
    _isxPop.vgaSignalView = [[skyVGASignalView alloc] initWithStyle:UITableViewStylePlain];
    _isxPop.vgaSignalView.myDataSource = [_myDelegate isxWinVGASignalDataSource];
    _isxPop.vgaSignalView.myDelegate = self;
    
    _isxPop.hdmiSignalView = [[skyHDMISignalView alloc] initWithStyle:UITableViewStylePlain];
    _isxPop.hdmiSignalView.myDataSource = [_myDelegate isxWinHDMISignalDataSource];
    _isxPop.hdmiSignalView.myDelegate = self;
    
    _isxPop.dviSignalView = [[skyDVISignalView alloc] initWithStyle:UITableViewStylePlain];
    _isxPop.dviSignalView.myDataSource = [_myDelegate isxWinDVISignalDataSource];
    _isxPop.dviSignalView.myDelegate = self;

    
    // 更新窗口UI
    [self updateWindowUI];
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

#pragma mark - skyISXWinPopoverVC Delegate
// 窗口进入全屏
- (void)enterFullScreen
{
    if (!bBigPicture)
    {
        // 代理控制器处理全屏消息
        [_myDelegate isxWinFullScreen:self];
        
        [_popView dismissPopoverAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"窗口全屏功能在大画面状态不能够使用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

// 大画面分解
- (void)splitBigScreen
{
    if (bBigPicture)
    {
        [_popView dismissPopoverAnimated:YES];
        
        // 代理控制器处理大画面分解消息
        [_myDelegate isxWinResolveScreen:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"大画面分解只能在窗口是大画面状态下使用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}


@end
