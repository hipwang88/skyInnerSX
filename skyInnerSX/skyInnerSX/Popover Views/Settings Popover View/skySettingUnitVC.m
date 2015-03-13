//
//  skySettingUnitVC.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skySettingUnitVC.h"
#import "skyMenuCell.h"
#import "skyStepperBtnCell.h"

#define kStepperButtonCell                  @"skySettperButtonCell"
#define kMenuCell                           @"skyMenuCell"

@interface skySettingUnitVC ()
{
    int nBrightnessValue;
    int nContrastValue;
}

///////////////////// Property ///////////////////////

///////////////////// Methods ////////////////////////
// 初始化控件
- (void)initializeComponents;
// 虚拟键盘开关事件函数
- (void)useKeyboardValueChangedEventHandler;
// 显示编号事件函数
- (void)showPanelNumEventHandler;
// 隐藏编号事件函数
- (void)hidePanelNumEventHandler;
// 屏幕开机事件函数
- (void)unitOnEventHandler;
// 屏幕关机事件函数
- (void)unitOffEventHandler;
// 白平衡自动调整事件函数
- (void)addjustWBEventHandler;
// 位置自动调整事件函数
- (void)addjusetPositionEventHandler;
// 亮度调整事件函数
- (void)brightnessValueChangedEventHandler;
// 对比度调整事件函数
- (void)contrastValueChangedEventHandler;
// 亮度复位事件函数
- (void)birghtnessResetEventHandler;
// 对比度服务事件函数
- (void)contrastResetEventHandler;
// 菜单按钮事件
- (void)menuBtnClick;
// 上按钮事件
- (void)upBtnClick;
// 下按钮事件
- (void)downBtnClick;
// 左按钮事件
- (void)leftBtnClick;
// 右按钮事件
- (void)rightBtnClick;
// 屏显按钮事件
- (void)panelDisplayBtnClick;
// 信号按钮事件
- (void)signalBtnClick;
// 确认按钮事件
- (void)confirmBtnClick;
// 退出按钮事件
- (void)quitBtnClick;
// 添加虚拟键盘
- (void)addVirtualBoard;
// 移除虚拟键盘
- (void)removeVirtualBoard;

///////////////////// Ends ///////////////////////////

@end

@implementation skySettingUnitVC

@synthesize myTableView = _myTableView;
@synthesize useKeyboardSwitch = _useKeyboardSwitch;
@synthesize myDelegate = _myDelegate;
@synthesize selectionView = _selectionView;

#pragma mark - skySettingUnitVC Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化控件
    [self initializeComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - skySettingUnitVC Private Methods
// 初始化控件
- (void)initializeComponents
{
    // 注册自定义Cell
    [_myTableView registerNib:[UINib nibWithNibName:@"skyStepperBtnCell" bundle:nil] forCellReuseIdentifier:kStepperButtonCell];
    [_myTableView registerNib:[UINib nibWithNibName:@"skyMenuCell" bundle:nil] forCellReuseIdentifier:kMenuCell];
    
    // 初始化虚拟键盘开关
    _useKeyboardSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _useKeyboardSwitch.on = NO;
    [_useKeyboardSwitch addTarget:self action:@selector(useKeyboardValueChangedEventHandler) forControlEvents:UIControlEventValueChanged];
    
    // 数值
    nBrightnessValue = 256;
    nContrastValue = 256;
}

// 虚拟键盘开关事件函数
- (void)useKeyboardValueChangedEventHandler
{
    if (_useKeyboardSwitch.isOn)
    {
        [self addVirtualBoard];
    }
    else
    {
        [self removeVirtualBoard];
    }
}

// 显示编号事件函数
- (void)showPanelNumEventHandler
{
    [_myDelegate showPanelNum];
}

// 隐藏编号事件函数
- (void)hidePanelNumEventHandler
{
    [_myDelegate hidePanelNum];
}

// 屏幕开机事件函数
- (void)unitOnEventHandler
{
    [_myDelegate unitOn];
}

// 屏幕关机事件函数
- (void)unitOffEventHandler
{
    [_myDelegate unitOff];
}

// 白平衡自动调整事件函数
- (void)addjustWBEventHandler
{
    [_myDelegate addjustWB];
}

// 位置自动调整事件函数
- (void)addjusetPositionEventHandler
{
    [_myDelegate addjusetPosition];
}

// 亮度调整事件函数
- (void)brightnessValueChangedEventHandler
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    
    skyStepperBtnCell *cell = (skyStepperBtnCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    
    if (nBrightnessValue < (int)cell.cellStepper.value)
    {
        [_myDelegate brightnessIncrease];
    }
    else
    {
        [_myDelegate brightnessDecrease];
    }
    // 更新值
    nBrightnessValue = (int)cell.cellStepper.value;
    if (nBrightnessValue >=512 || nBrightnessValue <= 1)
    {
        cell.cellStepper.value = 256;
        nBrightnessValue = 256;
    }
}

// 对比度调整事件函数
- (void)contrastValueChangedEventHandler
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    
    skyStepperBtnCell *cell = (skyStepperBtnCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    
    if (nContrastValue < (int)cell.cellStepper.value)
    {
        [_myDelegate contrastIncrease];
    }
    else
    {
        [_myDelegate contrastDecrease];
    }
    // 更新值
    nContrastValue = (int)cell.cellStepper.value;
    if (nContrastValue >=512 || nContrastValue <= 1)
    {
        cell.cellStepper.value = 256;
        nContrastValue = 256;
    }
}

// 亮度复位事件函数
- (void)birghtnessResetEventHandler
{
    // 数值复位
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    skyStepperBtnCell *cell = (skyStepperBtnCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    cell.cellStepper.value = 256;
    nBrightnessValue = 256;
    
    // 协议发送
    [_myDelegate brightnessRest];
}

// 对比度服务事件函数
- (void)contrastResetEventHandler
{
    // 数值复位
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    skyStepperBtnCell *cell = (skyStepperBtnCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    cell.cellStepper.value = 256;
    nContrastValue = 256;
    
    // 协议发送
    [_myDelegate contrastRest];
}

// 菜单按钮事件
- (void)menuBtnClick
{
    [_myDelegate sendMenuClick];
}

// 上按钮事件
- (void)upBtnClick
{
    [_myDelegate sendUpClick];
}

// 下按钮事件
- (void)downBtnClick
{
    [_myDelegate sendDownClick];
}

// 左按钮事件
- (void)leftBtnClick
{
    [_myDelegate sendLeftClick];
}

// 右按钮事件
- (void)rightBtnClick
{
    [_myDelegate sendRightClick];
}

// 屏显按钮事件
- (void)panelDisplayBtnClick
{
    [_myDelegate sendPanelDisplayClick];
}

// 信号按钮事件
- (void)signalBtnClick
{
    [_myDelegate sendSignalClick];
}

// 确认按钮事件
- (void)confirmBtnClick
{
    [_myDelegate sendConfirmClick];
}

// 退出按钮事件
- (void)quitBtnClick
{
    [_myDelegate sendQuitClick];
}

// 添加虚拟键盘
- (void)addVirtualBoard
{
    [_myTableView beginUpdates];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:4];
    [_myTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
    
    [_myTableView endUpdates];
}

// 移除虚拟键盘
- (void)removeVirtualBoard
{
    [_myTableView beginUpdates];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:4];
    [_myTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
    
    [_myTableView endUpdates];
}

#pragma mark - skySettingUnitVC Public Methods

#pragma mark - Table view data source
// 计算Section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result = 4;
    
    if (_useKeyboardSwitch.isOn)    // 虚拟键盘开启
    {
        result = 5;
    }
    
    return result;
}

// 每个Section中的Cell数目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 1;
    
    switch (section)
    {
        case 0:
            result = 1;
            break;
            
        case 1:
            result = 6;
            break;
            
        case 2:
            result = 2;
            break;
            
        case 3:
            result = 1;
            break;
            
        case 4:
            result = 1;
            break;
    }
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)    // 机芯单元选择
    {
        static NSString *unitSelectionCellIdentifier = @"unitSelectionCellIdentifier";
        UITableViewCell *selectionCell = [tableView dequeueReusableCellWithIdentifier:unitSelectionCellIdentifier];
        
        if (selectionCell == nil)
        {
            selectionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unitSelectionCellIdentifier];
        }
        
        // 编辑Cell
        //selectionCell.textLabel.text = @"屏幕单元选择";
        selectionCell.textLabel.text = NSLocalizedString(@"UnitControl_Unit", nil);
        selectionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return selectionCell;
    }
    else if (indexPath.section == 1)    // 显示编号、隐藏编号、屏幕开启、屏幕关闭、位置自动调整、白平衡自动调整
    {
        static NSString *btnCellIdentifier = @"btnCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:btnCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:btnCellIdentifier];
        }
        
        // 编辑Cell
        switch (indexPath.row)
        {
            case 0: // 显示编号
                //cell.textLabel.text = @"显示编号";
                cell.textLabel.text = NSLocalizedString(@"UnitControl_ShowID", nil);
                cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.0 alpha:1.0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                break;
                
            case 1: // 隐藏编号
                //cell.textLabel.text = @"隐藏编号";
                cell.textLabel.text = NSLocalizedString(@"UnitControl_HideID", nil);
                cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.0 alpha:1.0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                break;
                
            case 2: // 屏幕开启
                //cell.textLabel.text = @"屏幕开启";
                cell.textLabel.text = NSLocalizedString(@"UnitControl_Power", nil);
                cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.0 alpha:1.0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                break;
                
            case 3: // 屏幕关闭
                //cell.textLabel.text = @"屏幕关闭";
                cell.textLabel.text = NSLocalizedString(@"UnitControl_Shutdown", nil);
                cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.0 alpha:1.0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                break;
                
            case 4: // 位置自动调整
                //cell.textLabel.text = @"位置自动调整";
                cell.textLabel.text = NSLocalizedString(@"UnitControl_Position", nil);
                cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.0 alpha:1.0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                break;
                
            case 5: // 白平衡自动调整
                //cell.textLabel.text = @"白平衡自动调整";
                cell.textLabel.text = NSLocalizedString(@"UnitControl_Balance", nil);
                cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.0 alpha:1.0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                break;
        }
        
        return cell;
    }
    else if (indexPath.section == 2)    // 亮度对比度调整
    {
        skyStepperBtnCell *stepperBtnCell = (skyStepperBtnCell *)[tableView dequeueReusableCellWithIdentifier:kStepperButtonCell];
        
        switch (indexPath.row)
        {
            case 0: // 亮度调整
                //stepperBtnCell.cellTitle.text = @"亮度调整";
                stepperBtnCell.cellTitle.text = NSLocalizedString(@"UnitControl_Brightness", nil);
                stepperBtnCell.cellStepper.minimumValue = 0;
                stepperBtnCell.cellStepper.maximumValue = 512;
                stepperBtnCell.cellStepper.stepValue = 1;
                stepperBtnCell.cellStepper.value = nBrightnessValue;
                [stepperBtnCell.cellStepper addTarget:self action:@selector(brightnessValueChangedEventHandler) forControlEvents:UIControlEventValueChanged];
                //[stepperBtnCell.cellBtn setTitle:@"复位" forState:UIControlStateNormal];
                //[stepperBtnCell.cellBtn setTitle:@"复位" forState:UIControlStateHighlighted];
                [stepperBtnCell.cellBtn setTitle:NSLocalizedString(@"UnitControl_Reset", nil) forState:UIControlStateNormal];
                [stepperBtnCell.cellBtn setTitle:NSLocalizedString(@"UnitControl_Reset", nil) forState:UIControlStateHighlighted];
                [stepperBtnCell.cellBtn addTarget:self action:@selector(birghtnessResetEventHandler) forControlEvents:UIControlEventTouchUpInside];
                stepperBtnCell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 1: // 对比度调整
                //stepperBtnCell.cellTitle.text = @"对比度调整";
                stepperBtnCell.cellTitle.text = NSLocalizedString(@"UnitControl_Contrast", nil);
                stepperBtnCell.cellStepper.minimumValue = 0;
                stepperBtnCell.cellStepper.maximumValue = 512;
                stepperBtnCell.cellStepper.stepValue = 1;
                stepperBtnCell.cellStepper.value = nContrastValue;
                [stepperBtnCell.cellStepper addTarget:self action:@selector(contrastValueChangedEventHandler) forControlEvents:UIControlEventValueChanged];
                //[stepperBtnCell.cellBtn setTitle:@"复位" forState:UIControlStateNormal];
                //[stepperBtnCell.cellBtn setTitle:@"复位" forState:UIControlStateHighlighted];
                [stepperBtnCell.cellBtn setTitle:NSLocalizedString(@"UnitControl_Reset", nil) forState:UIControlStateNormal];
                [stepperBtnCell.cellBtn setTitle:NSLocalizedString(@"UnitControl_Reset", nil) forState:UIControlStateHighlighted];
                [stepperBtnCell.cellBtn addTarget:self action:@selector(contrastResetEventHandler) forControlEvents:UIControlEventTouchUpInside];
                stepperBtnCell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
        }
        
        // 按钮效果
        for (id obj in stepperBtnCell.subviews)
        {
            if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *)obj;
                scroll.delaysContentTouches = NO;
                
                break;
            }
        }
        
        return stepperBtnCell;
    }
    else if (indexPath.section == 3)    // 虚拟键盘控制开关
    {
        static NSString *useVirtualBoardCellIdentifier = @"useVirtualBoardCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:useVirtualBoardCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:useVirtualBoardCellIdentifier];
        }
        
        // 属性设置
        //cell.textLabel.text = @"虚拟键盘";
        cell.textLabel.text = NSLocalizedString(@"UnitControl_Virtual", nil);
        cell.accessoryView = _useKeyboardSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else                                // 虚拟键盘
    {
        skyMenuCell *menuCell = (skyMenuCell *)[tableView dequeueReusableCellWithIdentifier:kMenuCell];
        
        // 绑定事件
        [menuCell.menuBtn addTarget:self action:@selector(menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [menuCell.upBtn addTarget:self action:@selector(upBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [menuCell.downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [menuCell.leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [menuCell.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [menuCell.panelBtn addTarget:self action:@selector(panelDisplayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [menuCell.signalBtn addTarget:self action:@selector(signalBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [menuCell.confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [menuCell.quitBtn addTarget:self action:@selector(quitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 按钮效果
        for (id obj in menuCell.subviews)
        {
            if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *)obj;
                scroll.delaysContentTouches = NO;
                
                break;
            }
        }
        
        return menuCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat fHeight = 44.0f;
    
    if (_useKeyboardSwitch.isOn && indexPath.section == 4)
    {
        fHeight = 166.0f;
    }
    
    return fHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = nil;
    
    switch (section)
    {
        case 0:
            //result = @"显示单元选择";
            result = NSLocalizedString(@"UnitControl_Unit_Title", nil);
            break;
            
        case 1:
            //result = @"单元控制";
            result = NSLocalizedString(@"UnitControl_ConUnit", nil);
            break;
            
        case 2:
            //result = @"亮度对比度调整";
            result = NSLocalizedString(@"UnitControl_Adjust", nil);
            break;
            
        case 3:
            //result = @"开启虚拟键盘控制菜单";
            result = NSLocalizedString(@"UnitControl_VirtualTitle", nil);
            break;
            
        case 4:
            //result = @"虚拟按键";
            result = NSLocalizedString(@"UnitControl_VirtualButton", nil);
            break;
    }
    
    return result;
}

#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)         // 单元选择
    {
        [_selectionView.tableView reloadData];
        [self.navigationController pushViewController:_selectionView animated:YES];
    }
    else if (indexPath.section == 1)    // 控制
    {
        switch (indexPath.row)
        {
            case 0: // 显示编号
                [self showPanelNumEventHandler];
                break;
                
            case 1: // 隐藏编号
                [self hidePanelNumEventHandler];
                break;
                
            case 2: // 屏幕开启
                [self unitOnEventHandler];
                break;
                
            case 3: // 屏幕关闭
                [self unitOffEventHandler];
                break;
                
            case 4: // 位置自动调整
                [self addjusetPositionEventHandler];
                break;
                
            case 5: // 白平衡自动调整
                [self addjustWBEventHandler];
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
