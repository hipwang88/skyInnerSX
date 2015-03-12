//
//  skySettingConfigVC.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skySettingConfigVC.h"
#import "skyStepperCell.h"

#define kTableStepperCell        @"skyStepperCell"

@interface skySettingConfigVC ()

///////////////////// Property ///////////////////////
@property (assign, nonatomic) int ScreenRow;
@property (assign, nonatomic) int ScreenColumn;

///////////////////// Methods ////////////////////////
// 初始化组件
- (void)initializeComponents;
// 屏幕拼接行数事件函数
- (void)screenRowsStepperEventHandler;
// 屏幕拼接列数事件函数
- (void)screenColumnsStepperEventHandler;
// 设置确认事件函数
- (void)confirmBtnEventHandler;

///////////////////// Ends ///////////////////////////

@end

@implementation skySettingConfigVC

@synthesize myTableView = _myTableView;
@synthesize myDelegate = _myDelegate;
@synthesize myDataSource = _myDataSource;
@synthesize ScreenRow = _ScreenRow;
@synthesize ScreenColumn = _ScreenColumn;

#pragma mark - skySettingConfigVC Methods
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
    // 控件初始化
    [self initializeComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize size = CGSizeMake(320.0f, 680.0f);
    self.preferredContentSize = size;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self forcePopoverSize];
}

- (void)forcePopoverSize
{
    CGSize currentSetSizeForPopover  = self.preferredContentSize;
    CGSize fakeMomentarySize = CGSizeMake(currentSetSizeForPopover.width, currentSetSizeForPopover.height);
    self.preferredContentSize = fakeMomentarySize;
    self.preferredContentSize = currentSetSizeForPopover;
}

#pragma mark - skySettingConfigVC Private Methods
// 初始化组件
- (void)initializeComponents
{
    // 初始化cell nib
    [_myTableView registerNib:[UINib nibWithNibName:@"skyStepperCell" bundle:nil] forCellReuseIdentifier:kTableStepperCell];
}
// 屏幕拼接行数事件函数
- (void)screenRowsStepperEventHandler
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    skyStepperCell *cell = (skyStepperCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    
    cell.lableValue.text = [NSString stringWithFormat:@"%d",(int)cell.valueStepper.value];
    
    _ScreenRow = (int)cell.valueStepper.value;
}

// 屏幕拼接列数事件函数
- (void)screenColumnsStepperEventHandler
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    skyStepperCell *cell = (skyStepperCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    
    cell.lableValue.text = [NSString stringWithFormat:@"%d",(int)cell.valueStepper.value];
    
    _ScreenColumn = (int)cell.valueStepper.value;
}

// 设置确认事件函数
- (void)confirmBtnEventHandler
{
    // 数据源设置
    [_myDataSource setCurrentScreenRow:_ScreenRow andColumn:_ScreenColumn];
    // 控制代理
    [_myDelegate setScreenRow:_ScreenRow andColumn:_ScreenColumn];
}

#pragma mark - skySettingConfigVC Public Methods

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    
    if (section == 0)
    {
        result = 2;
    }
    else if (section == 1)
    {
        result = 1;
    }
    
    return result;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        skyStepperCell *cell = (skyStepperCell *)[tableView dequeueReusableCellWithIdentifier:kTableStepperCell];
        
        switch (indexPath.row)
        {
            case 0:
                //cell.lableTitle.text = @"屏幕行数:";
                cell.lableTitle.text = NSLocalizedString(@"SpecSet_Row", nil);
                cell.lableValue.text = [NSString stringWithFormat:@"%d",[_myDataSource getCurrentScreenRow]];
                cell.valueStepper.minimumValue = 1;
                cell.valueStepper.maximumValue = 15;
                cell.valueStepper.stepValue = 1;
                cell.valueStepper.value = [_myDataSource getCurrentScreenRow];
                [cell.valueStepper addTarget:self action:@selector(screenRowsStepperEventHandler) forControlEvents:UIControlEventValueChanged];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 行数
                _ScreenRow = [_myDataSource getCurrentScreenRow];
                break;
                
            case 1:
                //cell.lableTitle.text = @"屏幕列数:";
                cell.lableTitle.text = NSLocalizedString(@"SpecSet_Column", nil);
                cell.lableValue.text = [NSString stringWithFormat:@"%d",[_myDataSource getCurrentScreenColumn]];
                cell.valueStepper.minimumValue = 1;
                cell.valueStepper.maximumValue = 15;
                cell.valueStepper.stepValue = 1;
                cell.valueStepper.value = [_myDataSource getCurrentScreenColumn];
                [cell.valueStepper addTarget:self action:@selector(screenColumnsStepperEventHandler) forControlEvents:UIControlEventValueChanged];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 列数
                _ScreenColumn = [_myDataSource getCurrentScreenColumn];
                break;
        }
        
        // 按钮效果
        for (id obj in cell.subviews)
        {
            if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *)obj;
                scroll.delaysContentTouches = NO;
                
                break;
            }
        }
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"skySettingConfigCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        // 设置确认cell
        //cell.textLabel.text = @"确认控制器设置";
        cell.textLabel.text = NSLocalizedString(@"SpecSet_Confirm", nil);
        cell.textLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.0 alpha:1.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = nil;
    
    if (section == 0)
    {
        //result = @"调整屏幕拼接规格";
        result = NSLocalizedString(@"SpecSet_Title", nil);
    }
    
    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *result = nil;
    
    if (section == 0)
    {
        //result = @"点击双选按钮进行值的加减";
        result = NSLocalizedString(@"SpecSet_Info", nil);
    }
    
    return result;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [self confirmBtnEventHandler];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
