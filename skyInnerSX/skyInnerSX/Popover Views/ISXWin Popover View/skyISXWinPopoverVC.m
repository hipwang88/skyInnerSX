//
//  skyISXWinPopoverVC.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyISXWinPopoverVC.h"

@interface skyISXWinPopoverVC ()

@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation skyISXWinPopoverVC

@synthesize cvbsSignalView = _cvbsSignalView;
@synthesize vgaSignalView = _vgaSignalView;
@synthesize hdmiSignalView = _hdmiSignalView;
@synthesize dviSignalView = _dviSignalView;
@synthesize myDelegate = _myDelegate;
@synthesize tableData = _tableData;
@synthesize array = _array;

#pragma mark - skyISXWinPopoverVC basic methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 菜单初始图标
    //self.title = @"窗口功能菜单";
    self.title = NSLocalizedString(@"WinMenu", nil);
    _array = [[NSMutableArray alloc] init];
    [_array addObject:[UIImage imageNamed:@"BigPic.png"]];
    [_array addObject:[UIImage imageNamed:@"Unit.png"]];
    [_array addObject:[UIImage imageNamed:@"cvbs_switch.png"]];
    [_array addObject:[UIImage imageNamed:@"vga_switch.png"]];
    [_array addObject:[UIImage imageNamed:@"hdmi_switch.png"]];
    [_array addObject:[UIImage imageNamed:@"dvi_switch.png"]];
    
    // 菜单项初始
    _tableData = [[NSMutableArray alloc] init];
    [_tableData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"WinMenu_Full", nil)]];
    [_tableData addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"WinMenu_Resolve", nil)]];
    [_tableData addObject:[NSString stringWithFormat:@"%@ CVBS",NSLocalizedString(@"WinMenu_SwitchSignal", nil)]];
    [_tableData addObject:[NSString stringWithFormat:@"%@ VGA",NSLocalizedString(@"WinMenu_SwitchSignal", nil)]];
    [_tableData addObject:[NSString stringWithFormat:@"%@ HDMI",NSLocalizedString(@"WinMenu_SwitchSignal", nil)]];
    [_tableData addObject:[NSString stringWithFormat:@"%@ DVI",NSLocalizedString(@"WinMenu_SwitchSignal", nil)]];

    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize size = CGSizeMake(320.0f, 550.0f);
    self.preferredContentSize = size;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self forcePopoverSize];
}

- (void)forcePopoverSize
{
    CGSize currentSetSizeForPopover  = self.preferredContentSize;//self.contentSizeForViewInPopover;
    CGSize fakeMomentarySize = CGSizeMake(currentSetSizeForPopover.width, currentSetSizeForPopover.height);
    self.preferredContentSize = fakeMomentarySize;
    self.preferredContentSize = currentSetSizeForPopover;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"skySCXWinPopoverIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [_array objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return @"功能选项";
    return NSLocalizedString(@"WinMenu_Title", nil);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    //return [NSString stringWithFormat:@"全屏：让拼接墙全屏显示本窗口\n大画面分解：将大画面状态窗口分解成单画面\nCVBS信号切换：点击进入CVBS信号切换页面选择输入信号\nVGA信号切换：点击进入VGA信号切换页面选择输入信号\nHDMI信号切换：点击进入HDMI信号切换页面选择输入信号\nDVI信号切换：点击进入DVI信号切换页面选择输入信号"];
    return [NSString stringWithFormat:@"%@",NSLocalizedString(@"WinMenu_Info", nil)];
}

#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0: // 全屏
            [_myDelegate enterFullScreen];
            break;
            
        case 1: // 大画面分解
            [_myDelegate splitBigScreen];
            break;
            
        case 2: // CVBS信号切换
            if ([_myDataSource getCVBSMatrixInputs] != 0)
            {
                [self.navigationController pushViewController:_cvbsSignalView animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SysInfo", nil) message:NSLocalizedString(@"SysInfo_noCVBSmatrix", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"SysInfo_OK", nil) otherButtonTitles:nil, nil];
                [alertView show];
            }
            break;
            
        case 3: // VGA信号切换
            if ([_myDataSource getVGAMatrixInputs] != 0)
            {
                [self.navigationController pushViewController:_vgaSignalView animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SysInfo", nil) message:NSLocalizedString(@"SysInfo_noVGAmatrix", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"SysInfo_OK", nil) otherButtonTitles:nil, nil];
                [alertView show];
            }
            break;
            
        case 4: // HDMI信号切换
            if ([_myDataSource getHDMIMatrixInputs] != 0)
            {
                [self.navigationController pushViewController:_hdmiSignalView animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SysInfo", nil) message:NSLocalizedString(@"SysInfo_noHDMImatrix", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"SysInfo_OK", nil) otherButtonTitles:nil, nil];
                [alertView show];
            }
            break;
            
        case 5: // DVI 信号切换
            if ([_myDataSource getDVIMatrixInputs] != 0)
            {
                [self.navigationController pushViewController:_dviSignalView animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SysInfo", nil) message:NSLocalizedString(@"SysInfo_noDVImatrix", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"SysInfo_OK", nil) otherButtonTitles:nil, nil];
                [alertView show];
            }
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
