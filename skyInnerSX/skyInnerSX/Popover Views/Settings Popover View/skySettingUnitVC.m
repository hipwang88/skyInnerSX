//
//  skySettingUnitVC.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skySettingUnitVC.h"

@interface skySettingUnitVC ()

///////////////////// Property ///////////////////////

///////////////////// Methods ////////////////////////
// 初始化控件
- (void)initializeComponents;

///////////////////// Ends ///////////////////////////

@end

@implementation skySettingUnitVC

@synthesize myTableView = _myTableView;
@synthesize useKeyboardSwitch = _useKeyboardSwitch;
@synthesize myDelegate = _myDelegate;
@synthesize myDataSource = _myDataSource;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
}

#pragma mark - skySettingUnitVC Public Methods

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"skySettingUnitCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    return cell;
}

#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
