//
//  skyModelViewController.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyModelViewController.h"
#import "skyModelCell.h"

@interface skyModelViewController ()

////////////////// Property /////////////////////
@property (nonatomic, strong) NSIndexPath *selectionIndex;

////////////////// Methods //////////////////////
// 长按手势识别器
- (void)handleLongPressEvent:(UILongPressGestureRecognizer *)gesture;
// 情景模式保存
- (void)handleModelSaveEvent:(id)sender;
// 情景模式删除
- (void)handleModelDeleteEvent:(id)sender;

// 情景模式加载 -- 拆分大画面
- (void)innerLoadModelSplitScreen:(NSString *)nIndex;
// 情景模式加载 -- 加载屏幕参数
- (void)innerLoadModelScreenStatus:(NSString *)nIndex;
// 情景模式加载 -- 加载信号通道
- (void)innerLoadModelSignalStatus:(NSString *)nIndex;

////////////////// Ends /////////////////////////

@end

@implementation skyModelViewController

@synthesize tableData = _tableData;
@synthesize myDelegate = _myDelegate;
@synthesize myDataSource = _myDataSource;
@synthesize selectionIndex = _selectionIndex;

#pragma mark - skyModelViewController Basic Methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"情景模式";;
    self.title = NSLocalizedString(@"ModeProfile", nil);
    _tableData = [[NSMutableArray alloc] initWithCapacity:18];
    for (int i = 1; i <= 18; i++)
    {
        NSString *str = [NSString stringWithFormat:@"%@ - %d",NSLocalizedString(@"ModeProfile", nil),i];
        [_tableData addObject:str];
    }
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - skyModelViewController Public Methods
// 情景模式状态保存
- (void)saveModelStatusToFile
{
    [_myDataSource saveModelDataSource];
}

#pragma mark - skyModelViewController Private Methods
// 长按手势识别器
- (void)handleLongPressEvent:(UILongPressGestureRecognizer *)gesture
{
    // 开始识别手势
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        skyModelCell *cell = (skyModelCell *)gesture.view;
        [cell becomeFirstResponder];
        _selectionIndex = [self.tableView indexPathForCell:cell];   // 获取选择的Cell
        
        UIMenuItem *itemSave = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"ModeProfile_save", nil) action:@selector(handleModelSaveEvent:)];
        UIMenuItem *itemDelete = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"ModeProfile_delete", <#comment#>) action:@selector(handleModelDeleteEvent:)];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:itemSave,itemDelete, nil]];
        [menu setTargetRect:cell.frame inView:self.tableView];
        [menu setMenuVisible:YES animated:YES];
    }
}

// 情景模式保存
- (void)handleModelSaveEvent:(id)sender
{
    int nRow = (int)_selectionIndex.row;
    
    // 保存情景模式
    [_myDelegate shootAppToImage:nRow];
    
    NSArray *array = [NSArray arrayWithObject:_selectionIndex];
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
}

// 情景模式删除
- (void)handleModelDeleteEvent:(id)sender
{
    int nRow = (int)_selectionIndex.row;
    
    // 删除情景模式
    [_myDelegate removeModelImage:nRow];
    
    NSArray *array = [NSArray arrayWithObject:_selectionIndex];
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];

}

// 情景模式加载 -- 拆分大画面
- (void)innerLoadModelSplitScreen:(NSString *)nIndex
{
    [_myDelegate loadModelSplit:[nIndex intValue]];
}

// 情景模式加载 -- 加载屏幕参数
- (void)innerLoadModelScreenStatus:(NSString *)nIndex
{
    [_myDelegate loadModelScreenStatus:[nIndex intValue]];
}

// 情景模式加载 -- 加载信号通道
- (void)innerLoadModelSignalStatus:(NSString *)nIndex
{
    [_myDelegate loadModelSignalStatus:[nIndex intValue]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 18;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"skyModelCell";
    skyModelCell *cell = (skyModelCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"skyModelCell" owner:self options:nil] objectAtIndex:0];
    }
    
    // 设置各个表项
    cell.modelName.text = [_tableData objectAtIndex:indexPath.row];
    cell.saveDate.text = @"";
    cell.modelImage.image = [_myDataSource getModelImageAtIndex:(int)indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    // 给cell添加手势识别
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressEvent:)];
    longGesture.minimumPressDuration = 0.5f;
    [cell addGestureRecognizer:longGesture];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int nIndex = (int)indexPath.row;
    
    // 判断情景是否可用
    if ([_myDataSource isModelCanBeUsedAtIndex:nIndex])
    {
        // 调用情景模式
        [self performSelector:@selector(innerLoadModelSplitScreen:) withObject:[NSString stringWithFormat:@"%d",nIndex] afterDelay:0];
        [self performSelector:@selector(innerLoadModelScreenStatus:) withObject:[NSString stringWithFormat:@"%d",nIndex] afterDelay:0.4];
        [self performSelector:@selector(innerLoadModelSignalStatus:) withObject:[NSString stringWithFormat:@"%d",nIndex] afterDelay:0.8];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SysInfo", nil) message:NSLocalizedString(@"ModeProfile_NoMode", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"SysInfo_OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
