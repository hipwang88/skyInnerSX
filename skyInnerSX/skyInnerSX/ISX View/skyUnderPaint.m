//
//  skyUnderPaint.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-26.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyUnderPaint.h"

@interface skyUnderPaint()
{
    int     nTotalUnits;
    CGPoint startPoint;
}

/////////////////// Property /////////////////////
@property (assign, nonatomic) int nRows;            // 拼接行数
@property (assign, nonatomic) int nColumns;         // 拼接列数
@property (assign, nonatomic) int nUnitWidth;       // 单元宽度
@property (assign, nonatomic) int nUnitHeight;      // 单元高度
@property (assign, nonatomic) int nSpliceWidth;     // 控制区宽度
@property (assign, nonatomic) int nSpliceHeight;    // 控制区高度

/////////////////// Methods //////////////////////
// 绘制背景Logo
- (void)drawLogoImage:(CGContextRef)context;
// 绘制实线外框
- (void)drawFrameWithSolidLine:(CGContextRef)context;
// 绘制虚线四分线
- (void)drawQuartWithDotLine:(CGContextRef)context;
// 绘制机芯编号
- (void)drawUnitID:(CGContextRef)context;

/////////////////// Ends /////////////////////////

@end

@implementation skyUnderPaint

@synthesize myDataSource = _myDataSource;
@synthesize nRows = _nRows;
@synthesize nColumns = _nColumns;
@synthesize nUnitWidth = _nUnitWidth;
@synthesize nUnitHeight = _nUnitHeight;
@synthesize nSpliceWidth = _nSpliceWidth;
@synthesize nSpliceHeight = _nSpliceHeight;

#pragma mark - skyUnderPaint Public Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 设置水印logo
        UIColor *bkColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.bmp"]];
        [self setBackgroundColor:bkColor];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // 设置水印logo
        UIColor *bkColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.bmp"]];
        [self setBackgroundColor:bkColor];
        // 获取规格进行重绘
        [self getUnderPaintSpec];
    }
    
    return self;
}

// 获取控制区起始点
- (CGPoint)getStartCanvasPoint
{
    return startPoint;
}

// 规格获取
- (void)getUnderPaintSpec
{
    // 通过代理方式获取规格
    _nRows = [_myDataSource getSpliceRows];
    _nColumns = [_myDataSource getSpliceColumns];
    _nUnitWidth = [_myDataSource getSpliceUnitWidth];
    _nUnitHeight = [_myDataSource getSpliceUnitHeight];
    _nSpliceWidth = [_myDataSource getScreenWidth];
    _nSpliceHeight = [_myDataSource getScreenHeight];
    
    // 机芯单元总数
    nTotalUnits = _nRows * _nColumns;
    
    startPoint.x = (CGFloat)((1024 - _nSpliceWidth)/2);
    startPoint.y = (CGFloat)((804 - _nSpliceHeight)/2);
    
    // 获取重绘
    [self setNeedsDisplay];
}

#pragma mark - skyUnderPaint Private Methods
// 绘制背景图片
- (void)drawLogoImage:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    UIImage *image = [UIImage imageNamed:@"SMC_Logo.jpg"];
    [image drawInRect:CGRectMake(startPoint.x, startPoint.y, _nSpliceWidth, _nSpliceHeight)];
    
    UIGraphicsPopContext();
}

// 绘制实线外框
- (void)drawFrameWithSolidLine:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    // 设置线宽
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    
    // 竖线
    for (int i = 0; i <= _nColumns; i++)
    {
        CGContextMoveToPoint(context, startPoint.x+i*2*_nUnitWidth, startPoint.y);
        CGContextAddLineToPoint(context, startPoint.x+i*2*_nUnitWidth, startPoint.y+_nSpliceHeight);
    }
    // 横线
    for (int i = 0; i <= _nRows; i++)
    {
        CGContextMoveToPoint(context, startPoint.x, startPoint.y+i*2*_nUnitHeight);
        CGContextAddLineToPoint(context, startPoint.x+_nSpliceWidth, startPoint.y+i*2*_nUnitHeight);
    }
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

// 绘制虚线四分线
- (void)drawQuartWithDotLine:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGFloat length[2] = {10.0f,10.0f};
    CGContextSetLineDash(context, 0, length, 2);
    
    // 竖线
    for (int i = 0; i < _nColumns; i++)
    {
        CGContextMoveToPoint(context, startPoint.x+i*2*_nUnitWidth+_nUnitWidth, startPoint.y+1);
        CGContextAddLineToPoint(context, startPoint.x+i*2*_nUnitWidth+_nUnitWidth, startPoint.y+_nSpliceHeight);
    }
    // 横线
    for (int i = 0; i < _nRows; i++)
    {
        CGContextMoveToPoint(context, startPoint.x+1, startPoint.y+i*2*_nUnitHeight+_nUnitHeight);
        CGContextAddLineToPoint(context, startPoint.x+_nSpliceWidth, startPoint.y+i*2*_nUnitHeight+_nUnitHeight);
    }
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

// 绘制机芯编号
- (void)drawUnitID:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    long posX,posY,offsetX,offsetY;
    
    offsetX = startPoint.x+8;
    offsetY = startPoint.y+8;
    
    UIFont *helveticaBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f];
    UIColor *textColor = [UIColor whiteColor];
    [textColor set];
    
    for (int i = 1; i <= nTotalUnits; i++)
    {
        posX = ((i-1) % _nColumns) * _nUnitWidth * 2 + offsetX;
        posY = ((i-1) / _nColumns) * _nUnitHeight * 2 + offsetY;
        
        NSString *numberID = [NSString stringWithFormat:@"%d",i];
        
        // 绘制
        //[numberID drawAtPoint:CGPointMake(posX, posY) withFont:helveticaBold];
        [numberID drawAtPoint:CGPointMake(posX, posY) withAttributes:@{NSFontAttributeName: helveticaBold}];
    }
    
    UIGraphicsPopContext();
}

#pragma mark - skyUnderPaint Override Methods
// 重绘UIView
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制背景logo
    [self drawLogoImage:context];
    // 绘制实线外框
    [self drawFrameWithSolidLine:context];
    // 绘制虚线四分线
    [self drawQuartWithDotLine:context];
    // 绘制机芯编号
    [self drawUnitID:context];
}

@end
