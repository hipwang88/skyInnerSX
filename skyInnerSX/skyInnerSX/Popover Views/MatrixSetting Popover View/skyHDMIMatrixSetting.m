//
//  skyHDMIMatrixSetting.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-24.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyHDMIMatrixSetting.h"
#import "skySliderCell.h"

#define kSliderCell         @"skySliderCell"

@interface skyHDMIMatrixSetting ()

/////////////////// Property //////////////////////

/////////////////// Methods ///////////////////////
// 控件初始化
- (void)initializeComponents;
// 启用开关事件函数
- (void)switchValueChangedEventHandler;
// Slider数值改变事件函数
- (void)sliderValueChangedEventHandler;
// 矩阵确认设置事件函数
- (void)confirmMatrixSetEventHandler;
// 增加输入设置Cell
- (void)addInputCell;
// 删除输入设置Cell
- (void)removeInputCell;

/////////////////// Ends //////////////////////////

@end

@implementation skyHDMIMatrixSetting

@synthesize myTableView = _myTableView;
@synthesize useHDMISwitch = _useHDMISwitch;
@synthesize myDataSource = _myDataSource;

#pragma mark - skyHDMIMatrixSetting Methods

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - skyHDMIMatrixSetting Override Function
// 载入响应函数
- (void)pushViewToFront
{
    [super pushViewToFront];
    
    // 载入界面时重新计算状态
    _useHDMISwitch.on = [_myDataSource getCurrentHDMIInputs] != 0 ? YES : NO;
    [_myTableView reloadData];
}

#pragma mark - skyHDMIMatrixSetting Private Methods
// 控件初始化
- (void)initializeComponents
{
    // 初始化TableView Nibs
    [_myTableView registerNib:[UINib nibWithNibName:@"skySliderCell" bundle:nil] forCellReuseIdentifier:kSliderCell];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    // 初始化矩阵使用开关
    _useHDMISwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _useHDMISwitch.on = [_myDataSource getCurrentHDMIInputs] != 0 ? YES : NO;
    [_useHDMISwitch addTarget:self action:@selector(switchValueChangedEventHandler) forControlEvents:UIControlEventValueChanged];
}

// 启用开关事件函数
- (void)switchValueChangedEventHandler
{
    if (_useHDMISwitch.isOn)
    {
        [self addInputCell];
    }
    else
    {
        [self removeInputCell];
    }
}

// Slider数值改变事件函数
- (void)sliderValueChangedEventHandler
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    skySliderCell *cell = (skySliderCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    
    int nValue = (int)(cell.cellSilder.value + 0.5);
    cell.cellSilder.value = nValue;
    cell.labelValue.text = [NSString stringWithFormat:@"%d",nValue];
}

// 矩阵确认设置事件函数
- (void)confirmMatrixSetEventHandler
{
    if (_useHDMISwitch.isOn)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        skySliderCell *cell = (skySliderCell *)[_myTableView cellForRowAtIndexPath:indexPath];
        
        [_myDataSource setCurrentHDMIInputs:(int)(cell.cellSilder.value+0.5)];
    }
    else
    {
        [_myDataSource setCurrentHDMIInputs:0];
    }
}

// 增加输入设置Cell
- (void)addInputCell
{
    // 开启将输入值变为16
    [_myDataSource setCurrentHDMIInputs:16];
    
    // 编辑TableView
    [_myTableView beginUpdates];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [_myTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
    
    [_myTableView endUpdates];
}

// 删除输入设置Cell
- (void)removeInputCell
{
    // 编辑TableView
    [_myTableView beginUpdates];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [_myTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
    
    [_myTableView endUpdates];
    
    // 完成编辑将输入值变为0
    [_myDataSource setCurrentHDMIInputs:0];
}

#pragma mark - skyHDMIMatrixSetting Public Methods

#pragma mark - Table view data source
// 开关启用显示输入调整框
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result = 2;
    
    if (_useHDMISwitch.isOn)
        result = 3;
    
    return result;
}

// 每个Section中的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int nValue = [_myDataSource getCurrentHDMIInputs];
    
    if (indexPath.section == 0)
    {
        // 矩阵启用选择
        static NSString *cellIdentifier = @"skyHDMIMatrixSettingCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        // 布置cell外观
        cell.textLabel.text = @"启用HDMI矩阵";
        cell.accessoryView = _useHDMISwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 设置状态
        [_useHDMISwitch setOn:nValue != 0];
        
        return cell;
    }
    else
    {
        if (_useHDMISwitch.isOn && indexPath.section == 1)
        {
            // 矩阵输入路数设定
            skySliderCell *sliderCell = (skySliderCell *)[tableView dequeueReusableCellWithIdentifier:kSliderCell];
            
            // 刚刚启用
            nValue = nValue == 0 ? 1 : nValue;
            
            // 布置外观
            sliderCell.labelTitle.text = @"矩阵输入路数";
            sliderCell.labelValue.text = [NSString stringWithFormat:@"%d",nValue];
            sliderCell.cellSilder.minimumValue = 1;
            sliderCell.cellSilder.maximumValue = 256;
            sliderCell.cellSilder.continuous = NO;
            sliderCell.cellSilder.value = nValue;
            [sliderCell.cellSilder addTarget:self action:@selector(sliderValueChangedEventHandler) forControlEvents:UIControlEventTouchDragInside];
            sliderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return sliderCell;
        }
        else
        {
            static NSString *cellIdentifer = @"skyHDMIMatrixSettingBtnCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
            }
            
            // 布置cell
            cell.textLabel.text = @"确认矩阵设置";
            cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.0 alpha:1.0];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_useHDMISwitch.isOn && indexPath.section == 1)
    {
        return 75.0f;
    }
    else
    {
        return 44.0f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = nil;
    
    if (section == 0)
    {
        result = @"滑块控制矩阵启用";
    }
    
    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *result = nil;
    
    if (_useHDMISwitch.isOn && section == 1)
    {
        result = @"矩阵输入路数范围[1,256]";
    }
    
    return result;
}

#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_useHDMISwitch.isOn)
    {
        if (indexPath.section == 2)
        {
            [self confirmMatrixSetEventHandler];
        }
    }
    else
    {
        if (indexPath.section == 1)
        {
            [self confirmMatrixSetEventHandler];
        }
    }
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 弹回上一个界面
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
