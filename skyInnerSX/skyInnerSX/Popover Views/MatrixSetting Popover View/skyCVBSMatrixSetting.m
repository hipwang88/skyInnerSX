//
//  skyCVBSMatrixSetting.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-24.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyCVBSMatrixSetting.h"
#import "skySliderCell.h"

#define kSliderCell         @"skySliderCell"

@interface skyCVBSMatrixSetting ()

///////////////////// Property ///////////////////////

///////////////////// Methods ////////////////////////
// 初始化控件
- (void)initializeComponents;
// Switch开关事件函数
- (void)switchValueChangedEventHandler;
// Slider数值变化事件函数
- (void)sliderValueChangedEventHandler;
// 增加输入设置Cell
- (void)addInputCell;
// 删除输入设置Cell
- (void)removeInputCell;

///////////////////// Ends ///////////////////////////

@end

@implementation skyCVBSMatrixSetting

@synthesize myTableView = _myTableView;
@synthesize useCVBSSwitch = _useCVBSSwitch;
@synthesize myDataSource = _myDataSource;

#pragma mark - skyCVBSMatrixSetting Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化控件
    [self initializeComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - skyCVBSMatrixSetting Private Methods
// 初始化控件
- (void)initializeComponents
{
    // 初始化TableView Nibs
    [_myTableView registerNib:[UINib nibWithNibName:@"skySliderCell" bundle:nil] forCellReuseIdentifier:kSliderCell];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    // 初始化矩阵使用开关
    _useCVBSSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _useCVBSSwitch.on = [_myDataSource getCurrentCVBSInputs] != 0 ? YES : NO;
    [_useCVBSSwitch addTarget:self action:@selector(switchValueChangedEventHandler) forControlEvents:UIControlEventValueChanged];
}

// Switch开关事件函数
- (void)switchValueChangedEventHandler
{
    if (_useCVBSSwitch.isOn)
    {
        [self addInputCell];
    }
    else
    {
        [self removeInputCell];
    }
}

// Slider数值变化事件函数
- (void)sliderValueChangedEventHandler
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    skySliderCell *cell = (skySliderCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    
    int nValue = (int)(cell.cellSilder.value + 0.5);
    cell.cellSilder.value = nValue;
    cell.labelValue.text = [NSString stringWithFormat:@"%d",nValue];
    
    // 代理调用
    [_myDataSource setCurrentCVBSInputs:nValue];
}

// 增加输入设置Cell
- (void)addInputCell
{
    // 开启将输入值变为16
    [_myDataSource setCurrentCVBSInputs:16];
    
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
}

#pragma mark - skyCVBSMatrixSetting Public Methods

#pragma mark - Table view data source
// 开关启用显示输入调整框
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result = 2;
    
    if (_useCVBSSwitch.isOn)
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
    if (indexPath.section == 0)
    {
        // 矩阵启用选择
        static NSString *cellIdentifier = @"skyCVBSMatrixSettingCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        // 布置cell外观
        cell.textLabel.text = @"启用CVBS矩阵";
        cell.accessoryView = _useCVBSSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 设置状态
        [_useCVBSSwitch setOn:[_myDataSource getCurrentCVBSInputs] != 0];
        
        return cell;
    }
    else
    {
        if (_useCVBSSwitch.isOn && indexPath.section == 1)
        {
            // 矩阵输入路数设定
            skySliderCell *sliderCell = (skySliderCell *)[tableView dequeueReusableCellWithIdentifier:kSliderCell];
            
            // 布置外观
            sliderCell.labelTitle.text = @"矩阵输入路数";
            sliderCell.labelValue.text = [NSString stringWithFormat:@"%d",[_myDataSource getCurrentCVBSInputs]];
            sliderCell.cellSilder.minimumValue = 1;
            sliderCell.cellSilder.maximumValue = 256;
            sliderCell.cellSilder.continuous = NO;
            sliderCell.cellSilder.value = [_myDataSource getCurrentCVBSInputs];
            [sliderCell.cellSilder addTarget:self action:@selector(sliderValueChangedEventHandler) forControlEvents:UIControlEventTouchDragInside];
            sliderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return sliderCell;
        }
        else
        {
            static NSString *cellIdentifer = @"skyCVBSMatrixSettingBtnCellIdentifier";
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
    if (_useCVBSSwitch.isOn && indexPath.section == 1)
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
    
    if (_useCVBSSwitch.isOn && section == 1)
    {
        result = @"矩阵输入路数范围[1,256]";
    }
    
    return result;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
