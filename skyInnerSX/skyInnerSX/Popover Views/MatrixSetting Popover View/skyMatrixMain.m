//
//  skyMatrixMain.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-24.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyMatrixMain.h"
#import "skyPopBaseViewController.h"

@interface skyMatrixMain ()

@end

@implementation skyMatrixMain

@synthesize matrixs = _matrixs;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = @"信号源设置";
        _matrixs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *cellIdentifier = @"MainMatrixCellIdentifier";
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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath section];
    skyPopBaseViewController *nextVC = [_matrixs objectAtIndex:row];
    nextVC.view.frame = self.view.frame;
    nextVC.preferredContentSize = self.preferredContentSize;
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
