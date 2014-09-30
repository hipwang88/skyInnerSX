//
//  skyExternWin.m
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-14.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#import "skyExternWin.h"

@interface skyExternWin ()

///////////////// Property //////////////////////
// 功能说明Label
@property (strong, nonatomic) UILabel *configLabel;
// CVBS新建按钮
@property (strong, nonatomic) UIButton *cvbsNew;
// VGA新建按钮
@property (strong, nonatomic) UIButton *vgaNew;
// 高清信号新建按钮
@property (strong, nonatomic) UIButton *hdmiNew;
// DVI信号新建按钮
@property (strong, nonatomic) UIButton *dviNew;

///////////////// Methods ///////////////////////
// 初始化功能部件
- (void)initializeComponets;
// CVBS新建按钮按下消息
- (void)cvbsBtnClickHandle:(id)sender;
// VGA新建按钮按下消息
- (void)vgaBtnClickHandle:(id)sender;
// HDMI新建按钮按下消息
- (void)hdmiBtnClickHandle:(id)sender;
// DVI新建按钮按下消息
- (void)dviBtnClickHandle:(id)sender;

///////////////// Ends //////////////////////////

@end

@implementation skyExternWin

@synthesize configLabel = _configLabel;
@synthesize cvbsNew = _cvbsNew;
@synthesize vgaNew = _vgaNew;
@synthesize hdmiNew = _hdmiNew;
@synthesize dviNew = _dviNew;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.sideAnimationDuration = 0.3f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    
    // 初始化
    [self initializeComponets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideExternWin
{
    [self dismissController:self.view];
}

// 初始化功能布局
- (void)initializeComponets
{
    NSInteger frameWidth = 1024;
    // 功能说明
    CGRect labelFrame = CGRectMake(20, 0, 700, 44);
    _configLabel = [[UILabel alloc] initWithFrame:labelFrame];
    //_configLabel.textAlignment = UITextAlignmentLeft;
    _configLabel.textAlignment = NSTextAlignmentLeft;
    _configLabel.backgroundColor = [UIColor clearColor];
    _configLabel.textColor = [UIColor whiteColor];
    _configLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    _configLabel.text = @"功能扩展视图，请根据需要点击右侧按钮！";
    
    // 模拟信号新建
    CGRect cvbsBtnFrame = CGRectMake(frameWidth-210, 2, 40, 40);
    _cvbsNew = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cvbsNew setFrame:cvbsBtnFrame];
    [self.cvbsNew setBackgroundImage:[UIImage imageNamed:@"CVBSNor"] forState:UIControlStateNormal];
    [self.cvbsNew setBackgroundImage:[UIImage imageNamed:@"CVBSDown"] forState:UIControlStateHighlighted];
    [self.cvbsNew addTarget:self action:@selector(cvbsBtnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    // VGA
    CGRect vgaBtnFrame = CGRectMake(frameWidth-160, 2, 40, 40);
    _vgaNew = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.vgaNew setFrame:vgaBtnFrame];
    [self.vgaNew setBackgroundImage:[UIImage imageNamed:@"VGANor"] forState:UIControlStateNormal];
    [self.vgaNew setBackgroundImage:[UIImage imageNamed:@"VGADown"] forState:UIControlStateHighlighted];
    [self.vgaNew addTarget:self action:@selector(vgaBtnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    // 高清信号新建
    CGRect hdmiBtnFrame = CGRectMake(frameWidth-110, 2, 40, 40);
    _hdmiNew = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hdmiNew setFrame:hdmiBtnFrame];
    [self.hdmiNew setBackgroundImage:[UIImage imageNamed:@"HDMINor"] forState:UIControlStateNormal];
    [self.hdmiNew setBackgroundImage:[UIImage imageNamed:@"HDMIDown"] forState:UIControlStateHighlighted];
    [self.hdmiNew addTarget:self action:@selector(hdmiBtnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    // DVI
    CGRect dviBtnFrame = CGRectMake(frameWidth-60, 2, 40, 40);
    _dviNew = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dviNew setFrame:dviBtnFrame];
    [self.dviNew setBackgroundImage:[UIImage imageNamed:@"DVINor"] forState:UIControlStateNormal];
    [self.dviNew setBackgroundImage:[UIImage imageNamed:@"DVIDown"] forState:UIControlStateHighlighted];
    [self.dviNew addTarget:self action:@selector(dviBtnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    // 加入手势还原说明文字
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetConfigLabel)];
    tap.delegate = self;
    
    // 将组件加入视图
    [self.view addSubview:_configLabel];
    [self.view addSubview:_cvbsNew];
    [self.view addSubview:_vgaNew];
    [self.view addSubview:_hdmiNew];
    [self.view addSubview:_dviNew];
    [self.view addGestureRecognizer:tap];
}

// 还原说明文字
- (void)resetConfigLabel
{
    _configLabel.text = @"功能扩展视图，请根据需要点击右侧按钮！";
}

#pragma mark - UIGestureRecognizerDelegate
// UITapGestureRecgnizer
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

#pragma mark - Message Dump
// CVBS新建按钮按下消息
- (void)cvbsBtnClickHandle:(id)sender
{
    _configLabel.text = @"CVBS信号新建：所有窗口以CVBS信号一对一输出。";
    
    // 通过代理对象发送模拟新建功能
    [_delegate newSignalWithCVBS];
}

// VGA新建按钮按下消息
- (void)vgaBtnClickHandle:(id)sender
{
    _configLabel.text = @"VGA信号新建：所有窗口以VGA信号一对一输出。";
    
    [_delegate newSignalWithVGA];
}

// HDMI新建按钮按下消息
- (void)hdmiBtnClickHandle:(id)sender
{
    _configLabel.text = @"HDMI信号新建：所有窗口以HDMI信号一对一输出。";
    
    // 通过代理对象发送高清新建功能
    [_delegate newSignalWithHDMI];
}

// DVI新建按钮按下消息
- (void)dviBtnClickHandle:(id)sender
{
    _configLabel.text = @"DVI信号新建：所有窗口以DVI信号一对一输出。";
    
    [_delegate newSignalWithDVI];
}

@end
