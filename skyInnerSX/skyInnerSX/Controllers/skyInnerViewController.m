//
//  skyInnerViewController.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyInnerViewController.h"
#import "AppDelegate.h"

@interface skyInnerViewController ()
{
    
}

////////////////////////// Property /////////////////////////////
// 导航栏属性
@property (strong, nonatomic) UIBarButtonItem *settingButton;               // 导航栏设置按钮
@property (strong, nonatomic) UIBarButtonItem *modelButton;                 // 导航栏情景模式按钮
@property (strong, nonatomic) UIBarButtonItem *externButton;                // 导航栏扩展视图按钮

// 应用程序委托对象
@property (weak, nonatomic) AppDelegate *appDelegate;

////////////////////////// Methods //////////////////////////////
/****************** 初始化处理 *******************/
// 1.初始化导航栏
- (void)initializeNavigationItem;
// 2.初始化弹出视图
- (void)initializePopoverView;
// 3.初始化拼接主控区域
- (void)initializeSpliceArea;
// 4.初始化扩展功能视图
- (void)initializeExternView;
// 5.初始化运行数据
- (void)initializeAppDatas;
// 6.初始化协议适配器
- (void)initializeProtocolAdaptor;

/****************** 导航栏按钮事件 ****************/
// 导航栏设置按钮事件函数
- (void)settingButtonEventHandler:(id)paramSender;
// 情景模式按钮事件函数
- (void)modelButtonEventHandler:(id)paramSender;
// 视图扩展按钮事件函数
- (void)externButtonEventHandler:(id)paramSender;

////////////////////////// Ends /////////////////////////////////

@end

@implementation skyInnerViewController

// synthesize
@synthesize settingsPopover = _settingsPopover;
@synthesize modelsPopover = _modelsPopover;
@synthesize currentPopover = _currentPopover;
@synthesize settingsNavgation = _settingsNavgation;
@synthesize modelsNavigation = _modelsNavigation;
@synthesize settingMainVC = _settingMainVC;
@synthesize modelVC = _modelVC;
@synthesize settingButton = _settingButton;
@synthesize modelButton = _modelButton;
@synthesize externButton = _externButton;
@synthesize appDelegate = _appDelegate;

#pragma mark - ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 获取应用程序委托对象
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    // 初始化运行数据
    [self initializeAppDatas];
    // 初始化导航栏
    [self initializeNavigationItem];
    // 初始化弹出视图
    [self initializePopoverView];
    // 初始化拼接主控区域
    [self initializeSpliceArea];
    // 初始化扩展功能视图
    [self initializeExternView];
    // 初始化协议适配器
    [self initializeProtocolAdaptor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

#pragma mark - Private Methods(Initializeres)
// 1.初始化导航栏
- (void)initializeNavigationItem
{
    // 导航栏左侧设置按钮加入
    self.settingButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonEventHandler:)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:_settingButton, nil]];
    
    // 导航栏右侧情景模式、扩展视图按钮加入
    self.modelButton = [[UIBarButtonItem alloc] initWithTitle:@"情景模式" style:UIBarButtonItemStylePlain target:self action:@selector(modelButtonEventHandler:)];
    self.externButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbarDrawMode"] style:UIBarButtonItemStylePlain target:self action:@selector(externButtonEventHandler:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:_externButton,_modelButton, nil]];
    
    // 应用程序名称、导航栏颜色设定
    self.title = @"创维群欣内置拼接控制系统";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:143.0f/255.0f blue:88.0f/255.0f alpha:1];
}

// 2.初始化弹出视图
- (void)initializePopoverView
{
    /****************** 设置页面弹出视图 **********************/
    // 设置主视图初始
    self.settingMainVC = [[skySettingMainVC alloc] initWithStyle:UITableViewStyleGrouped];
    self.settingsNavgation = [[UINavigationController alloc] initWithRootViewController:_settingMainVC];
    self.settingsPopover = [[UIPopoverController alloc] initWithContentViewController:_settingsNavgation];
    self.settingsPopover.popoverContentSize = CGSizeMake(320.0f, 680.0f);
    
    // 1.add skySettingConnectionVC
    skySettingConnectionVC *mySettingConnection = [[skySettingConnectionVC alloc] initWithNibName:@"skySettingConnection" bundle:nil];
    mySettingConnection.title = @"通讯连接设置";
    mySettingConnection.rowImage = [UIImage imageNamed:@"ConnSet.png"];
    mySettingConnection.myDelegate = self;
    mySettingConnection.myDataSource = _appDelegate.theApp;
    [_settingMainVC.controllers addObject:mySettingConnection];
    
    // 2.add skySettingConfigVC
    skySettingConfigVC *mySettingConfig = [[skySettingConfigVC alloc] init];
    mySettingConfig.title = @"规格参数设置";
    mySettingConfig.rowImage = [UIImage imageNamed:@"SCXSet.png"];
    [_settingMainVC.controllers addObject:mySettingConfig];
    
    // 3.add skySettingSignalVC
    skySettingSignalVC *mySettingSignal = [[skySettingSignalVC alloc] init];
    mySettingSignal.title = @"信号设置";
    mySettingSignal.rowImage = [UIImage imageNamed:@"SignalSet.png"];
    [_settingMainVC.controllers addObject:mySettingSignal];
    
    // 4.add skySettingUnitVC
    skySettingUnitVC *mySettingUnit = [[skySettingUnitVC alloc] init];
    mySettingUnit.title = @"屏幕控制";
    mySettingUnit.rowImage = [UIImage imageNamed:@"ProtocalSet.png"];
    [_settingMainVC.controllers addObject:mySettingUnit];
    
    /****************** 情景模式弹出视图 **********************/
    self.modelVC = [[skyModelViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.modelsNavigation = [[UINavigationController alloc] initWithRootViewController:_modelVC];
    self.modelsPopover = [[UIPopoverController alloc] initWithContentViewController:_modelsNavigation];
    self.modelsPopover.popoverContentSize = CGSizeMake(320.0f, 680.0f);
    
    // 设定当前弹出视图
    _currentPopover = _modelsPopover;
}

// 3.初始化拼接主控区域
- (void)initializeSpliceArea
{
    
}

// 4.初始化扩展功能视图
- (void)initializeExternView
{
    
}

// 5.初始化运行数据
- (void)initializeAppDatas
{
    
}

// 6.初始化协议适配器
- (void)initializeProtocolAdaptor
{
    
}

#pragma mark - Private Methods(Event Handler)
// 导航栏设置按钮事件函数
- (void)settingButtonEventHandler:(id)paramSender
{
    BOOL bFlag = [_settingsPopover isPopoverVisible];
    
    if (bFlag)
    {
        // 正在显示则隐藏
        [_settingsPopover dismissPopoverAnimated:YES];
    }
    else
    {
        // 没有在当前显示
        [_currentPopover dismissPopoverAnimated:YES];
        [_settingsPopover presentPopoverFromBarButtonItem:_settingButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        _currentPopover = _settingsPopover;
    }
}

// 情景模式按钮事件函数
- (void)modelButtonEventHandler:(id)paramSender
{
    BOOL bFlag = [_modelsPopover isPopoverVisible];
    
    if (bFlag)
    {
        // 正在显示则隐藏
        [_modelsPopover dismissPopoverAnimated:YES];
    }
    else
    {
        // 没显示则关闭其他视图后弹出显示
        [_currentPopover dismissPopoverAnimated:YES];
        [_modelsPopover presentPopoverFromBarButtonItem:_modelButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

// 视图扩展按钮事件函数
- (void)externButtonEventHandler:(id)paramSender
{
    NSLog(@"Extern");
}

#pragma mark - skySettingConnectionVC Delegate
// 连接控制器
- (void)connectToController:(NSString *)ipAddress andPort:(NSInteger)nPort
{
    
}

// 断开控制器
- (void)disconnectController
{
    
}

@end
