//
//  skySettingSignalVC.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skySettingSignalVC.h"

@interface skySettingSignalVC ()

///////////////////// Property ////////////////////////

///////////////////// Methods /////////////////////////
// 初始化视图控件
- (void)initializeComponents;

///////////////////// Ends ////////////////////////////

@end

@implementation skySettingSignalVC

@synthesize matrixs = _matrixs;
@synthesize myDataSource = _myDataSource;

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
    cvbsMatrixVC.myDataSource = self;
    [_matrixs addObject:cvbsMatrixVC];
    
    // add VGA matrix View Controller
    skyVGAMatrixSetting *vgaMatrixVC = [[skyVGAMatrixSetting alloc] initWithNibName:@"skyVGAMatrixSetting" bundle:nil];
    vgaMatrixVC.title = @"VGA矩阵设置";
    vgaMatrixVC.rowImage = [UIImage imageNamed:@"VGACardDown.png"];
    vgaMatrixVC.myDataSource = self;
    [_matrixs addObject:vgaMatrixVC];
    
    // add HDMI matrix View Controller
    skyHDMIMatrixSetting *hdmiMatrixVC = [[skyHDMIMatrixSetting alloc] initWithNibName:@"skyHDMIMatrixSetting" bundle:nil];
    hdmiMatrixVC.title = @"HDMI矩阵设置";
    hdmiMatrixVC.rowImage = [UIImage imageNamed:@"HDMICardDown.png"];
    hdmiMatrixVC.myDataSource = self;
    [_matrixs addObject:hdmiMatrixVC];
    
    // add DVI matrix View Controller
    skyDVIMatrixSetting *dviMatrixVC = [[skyDVIMatrixSetting alloc] initWithNibName:@"skyDVIMatrixSetting" bundle:nil];
    dviMatrixVC.title = @"DVI矩阵设置";
    dviMatrixVC.rowImage = [UIImage imageNamed:@"DVICardDown.png"];
    dviMatrixVC.myDataSource = self;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = nil;
    
    if (section == 0)
    {
        result = @"选择设置相关矩阵";
    }
    
    return result;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath section];
    skyPopBaseViewController *nextVC = [_matrixs objectAtIndex:row];
    nextVC.view.frame = self.view.frame;
    nextVC.preferredContentSize = self.preferredContentSize;
    [nextVC pushViewToFront];
    [self.navigationController pushViewController:nextVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - skyCVBSMatrixSetting DataSource
// 获取CVBS矩阵使用输入路数
- (int)getCurrentCVBSInputs
{
    return [_myDataSource getCVBSMatrixInputs];
}

// 设置CVBS矩阵使用输入路数
- (void)setCurrentCVBSInputs:(int)nInputs
{
    [_myDataSource setCVBSMatrixInputs:nInputs];
}

#pragma mark - skyVGAMatrixSetting DataSource
// 获取当前VGA输入路数
- (int)getCurrentVGAInputs
{
    return [_myDataSource getVGAMatrixInputs];
}

// 设置当前VGA输入路数
- (void)setCurrentVGAInputs:(int)nInputs
{
    [_myDataSource setVGAMatrixInputs:nInputs];
}

#pragma mark - skyHDMIMatrixSetting DataSource
// 获取当前HDMI矩阵输入路数
- (int)getCurrentHDMIInputs
{
    return [_myDataSource getHDMIMatrixInputs];
}

// 设置当前HDMI矩阵输入路数
- (void)setCurrentHDMIInputs:(int)nInputs
{
    [_myDataSource setHDMIMatrixInputs:nInputs];
}

#pragma mark - skyDVIMatrixSetting DataSource
// 获取当前DVI矩阵输入路数
- (int)getCurrentDVIInputs
{
    return [_myDataSource getDVIMatrixInputs];
}

// 设置当前DVI矩阵输入路数
- (void)setCurrentDVIInputs:(int)nInputs
{
    [_myDataSource setDVIMatrixInputs:nInputs];
}

@end
