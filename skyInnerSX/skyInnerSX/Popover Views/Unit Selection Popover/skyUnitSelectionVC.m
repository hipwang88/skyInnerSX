//
//  skyUnitSelectionVC.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-25.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyUnitSelectionVC.h"

@interface skyUnitSelectionVC ()

///////////////////// Property //////////////////////
@property (strong, nonatomic) NSMutableArray *selectionArray;               // 选择数组
@property (strong, nonatomic) UIBarButtonItem *selectAllBarItem;            // 全选按钮
@property (strong, nonatomic) UIBarButtonItem *unSelectAllBarItem;          // 全不选按钮
@property (assign, nonatomic) int nCountOfUnits;                            // 机芯单元总数

///////////////////// Methods ///////////////////////
// 初始化控件
- (void)initializeComponents;
// 全选按钮事件函数
- (void)selectAllEventHandler;
// 全不选按钮事件函数
- (void)unSelectAllEventHandler;

///////////////////// Ends //////////////////////////

@end

@implementation skyUnitSelectionVC

@synthesize myTable = _myTable;
@synthesize myDelegate = _myDelegate;
@synthesize myDataSource = _myDataSource;
@synthesize selectionArray = _selectionArray;
@synthesize selectAllBarItem = _selectAllBarItem;
@synthesize unSelectAllBarItem = _unSelectAllBarItem;

#pragma mark - skyUnitSelectionVC Methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = @"选择单元";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始控件
    [self initializeComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 选择数组初始
    _selectionArray = [_myDataSource getCurrentSelectionUnits];
    _nCountOfUnits = [_myDataSource getCountOfUnits];
}

#pragma mark - skyUnitSelectionVC Private Methods
// 初始化控件
- (void)initializeComponents
{
    // Navigation Bar Item初始
    _selectAllBarItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllEventHandler)];
    _unSelectAllBarItem = [[UIBarButtonItem alloc] initWithTitle:@"全不选" style:UIBarButtonItemStylePlain target:self action:@selector(unSelectAllEventHandler)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:_unSelectAllBarItem,_selectAllBarItem, nil]];
}

// 全选按钮事件函数
- (void)selectAllEventHandler
{
    NSLog(@"全选事件函数");
    
    // 数据更新
    [_selectionArray removeAllObjects];
    for (int i = 1; i <= _nCountOfUnits; i++)
    {
        NSString *obj = [NSString stringWithFormat:@"%d",i];
        [_selectionArray addObject:obj];
    }
    [_myDataSource setCurrentSelectionUnits:_selectionArray];
    // 代理函数 全选
    [_myDelegate selectAllUnit];
    
    [_myTable reloadData];
}

// 全不选按钮事件函数
- (void)unSelectAllEventHandler
{
    NSLog(@"全不选事件函数");
    
    // 数据更新
    [_selectionArray removeAllObjects];
    for (int i = 1; i <= _nCountOfUnits; i++)
    {
        NSString *obj = [NSString stringWithFormat:@"%d",i];
        if ([_selectionArray containsObject:obj])
        {
            [_selectionArray removeObject:obj];
        }
    }
    [_myDataSource setCurrentSelectionUnits:_selectionArray];
    // 代理函数 全选
    [_myDelegate unSelectAllUnit];
    
    [_myTable reloadData];

}

#pragma mark - skyUnitSelectionVC Public Methods

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_myDataSource getCountOfUnits];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UnitSelectionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // 设置单元选择Cell
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];

    // 判断选中情况
    if ([_selectionArray containsObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int nIndex = (int)indexPath.row+1;
    NSString *obj = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    
    if ([_selectionArray containsObject:obj])
    {
        // 取消选中
        [_selectionArray removeObject:obj];
        // 更新数据源
        [_myDataSource setCurrentSelectionUnits:_selectionArray];
        // 代理函数 -- 取消选择
        [_myDelegate unSelectOneUnitAtIndex:nIndex];
    }
    else
    {
        // 选中单元
        [_selectionArray addObject:obj];
        // 更新数据源
        [_myDataSource setCurrentSelectionUnits:_selectionArray];
        // 代理函数 -- 选择单元
        [_myDelegate selectOneUnitAtIndex:nIndex];
    }
    
    // 更新数据
    _selectionArray = [_myDataSource getCurrentSelectionUnits];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 更新界面
    [tableView reloadData];
}

@end
