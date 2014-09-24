//
//  skySettingSignalVC.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skySettingSignalVC.h"
#import "skyCVBSMatrixSetting.h"
#import "skyVGAMatrixSetting.h"
#import "skyHDMIMatrixSetting.h"
#import "skyDVIMatrixSetting.h"

@interface skySettingSignalVC ()

///////////////////// Property ////////////////////////

///////////////////// Methods /////////////////////////
// 初始化视图控件
- (void)initializeComponents;

///////////////////// Ends ////////////////////////////

@end

@implementation skySettingSignalVC

@synthesize matrixs = _matrixs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _matrixs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化视图
    [self initializeComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - skySettingSignalVC Private methods
// 初始化视图控件
- (void)initializeComponents
{
    // add CVBS matrix View Controller
    skyCVBSMatrixSetting *cvbsMatrixVC = [[skyCVBSMatrixSetting alloc] initWithNibName:@"skyCVBSMatrixSetting" bundle:nil];
    cvbsMatrixVC.title = @"CVBS矩阵设置";
    cvbsMatrixVC.rowImage = [UIImage imageNamed:@"CVBSCardDown.png"];
    [_matrixs addObject:cvbsMatrixVC];
    
    // add VGA matrix View Controller
    skyVGAMatrixSetting *vgaMatrixVC = [[skyVGAMatrixSetting alloc] initWithNibName:@"skyVGAMatrixSetting" bundle:nil];
    vgaMatrixVC.title = @"VGA矩阵设置";
    vgaMatrixVC.rowImage = [UIImage imageNamed:@"VGACardDown.png"];
    [_matrixs addObject:vgaMatrixVC];
    
    // add HDMI matrix View Controller
    skyHDMIMatrixSetting *hdmiMatrixVC = [[skyHDMIMatrixSetting alloc] initWithNibName:@"skyHDMIMatrixSetting" bundle:nil];
    hdmiMatrixVC.title = @"HDMI矩阵设置";
    hdmiMatrixVC.rowImage = [UIImage imageNamed:@"HDMICardDown.png"];
    [_matrixs addObject:hdmiMatrixVC];
    
    // add DVI matrix View Controller
    skyDVIMatrixSetting *dviMatrixVC = [[skyDVIMatrixSetting alloc] initWithNibName:@"skyDVIMatrixSetting" bundle:nil];
    dviMatrixVC.title = @"DVI矩阵设置";
    dviMatrixVC.rowImage = [UIImage imageNamed:@"DVICardDown.png"];
    [_matrixs addObject:dviMatrixVC];
}

#pragma mark - Table view data source
// 根据载入视图控制器定义Section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_matrixs count];
}

// 每个Section中有一个Cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"skySettingSignalVCCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    NSInteger row = [indexPath section];
    skyPopBaseViewController *baseVC = [_matrixs objectAtIndex:row];
    cell.textLabel.text = baseVC.title;
    cell.imageView.image = baseVC.rowImage;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.0f;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath section];
    skyPopBaseViewController *nextVC = [_matrixs objectAtIndex:row];
    nextVC.view.frame = self.view.frame;
    nextVC.preferredContentSize = self.preferredContentSize;
    [self.navigationController pushViewController:nextVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
