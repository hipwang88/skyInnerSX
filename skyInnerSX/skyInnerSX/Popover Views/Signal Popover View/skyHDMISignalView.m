//
//  skyHDMISignalView.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-29.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skyHDMISignalView.h"
#import "definitions.h"
#import "skyCell1.h"
#import "skyCell2.h"

@interface skyHDMISignalView ()

//////////////////// Property ///////////////////////
@property (assign, nonatomic) BOOL isOpen;                      // 组是否展开
@property (strong, nonatomic) NSIndexPath *selectIndex;         // 选择索引
@property (assign, nonatomic) int hdmiInputs;

//////////////////// Methods ////////////////////////
// 数据初始化
- (void)initializeDefaults;
// 控制Row的显示与隐藏
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert;

//////////////////// Ends ///////////////////////////


@end

@implementation skyHDMISignalView

@synthesize isOpen = _isOpen;
@synthesize selectIndex = _selectIndex;
@synthesize hdmiInputs = _hdmiInputs;

#pragma mark - skyHDMISignalView Basic methods
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
    
    self.title = @"HDMI信号切换";
    _isOpen = NO;
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
    
    [self initializeDefaults];
    [self.tableView reloadData];
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

#pragma mark - skyHDMISignalView Private methods
// 数据初始化
- (void)initializeDefaults
{
    _hdmiInputs = [_myDataSource getHDMIMatrixInputs];
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
}

// 控制Row的显示与隐藏
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    skyCell1 *cell = (skyCell1 *)[self.tableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.tableView beginUpdates];
    
    NSInteger section = self.selectIndex.section;
    int contentCount;
    if (_selectIndex.section != _hdmiInputs / GROUP_NUMBER)
        contentCount = GROUP_NUMBER;
    else
        contentCount = _hdmiInputs % GROUP_NUMBER;
    
    
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i <= contentCount; i++)
    {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {
        [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.tableView endUpdates];
    
    if (nextDoInsert)
    {
        self.isOpen = YES;
        self.selectIndex = [self.tableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    
    if (self.isOpen)
        [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger nResult = 0;
    
    if (_hdmiInputs <= GROUP_NUMBER)
    {
        nResult = 1;
    }
    else
    {
        nResult = (_hdmiInputs-1) / GROUP_NUMBER + 1;
    }
    
    return nResult;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_hdmiInputs <= GROUP_NUMBER)
    {
        return _hdmiInputs;
    }
    else
    {
        if (self.isOpen)
        {
            if (self.selectIndex.section == section)
            {
                if (section != _hdmiInputs / GROUP_NUMBER)
                    return GROUP_NUMBER + 1;
                else
                    return _hdmiInputs % GROUP_NUMBER + 1;
            }
        }
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hdmiInputs <= GROUP_NUMBER)
    {
        static NSString *cellIdentifier = @"skyCell2";
        skyCell2 *cell = (skyCell2 *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"skyCell2" owner:self options:nil] objectAtIndex:0];
        }
        
        int nIndex = (int)(indexPath.section * GROUP_NUMBER + indexPath.row + 1);
        cell.titleLabel.text = [NSString stringWithFormat:@"HDMI-%d",nIndex];
        cell.imageShow.image = [UIImage imageNamed:@"signal_HDMI-Small.png"];
        // 别名
        cell.titleAlias.text = [_myDataSource getHDMIMatrixAliasAtIndex:(int)indexPath.row+1];
        
        return cell;
    }
    else
    {
        if (_isOpen && _selectIndex.section == indexPath.section && indexPath.row != 0) // 组展开后 节点绘制
        {
            static NSString *cellIdentifier = @"skyCell2";
            skyCell2 *cell = (skyCell2 *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"skyCell2" owner:self options:nil] objectAtIndex:0];
            }
            
            int nIndex = (int)(indexPath.section * GROUP_NUMBER + indexPath.row);
            cell.titleLabel.text = [NSString stringWithFormat:@"HDMI-%d",nIndex];
            cell.imageShow.image = [UIImage imageNamed:@"signal_HDMI-Small.png"];
            // 别名
            cell.titleAlias.text = [_myDataSource getHDMIMatrixAliasAtIndex:(int)indexPath.row+1];
            
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"Cell1";
            skyCell1 *cell = (skyCell1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"skyCell1" owner:self options:nil] objectAtIndex:0];
            }
            
            int nGroupIndex = (int)indexPath.section + 1;
            int nBegin = GROUP_NUMBER * (nGroupIndex - 1) + 1;
            int nEnd = GROUP_NUMBER * nGroupIndex;
            if (indexPath.section == _hdmiInputs / GROUP_NUMBER)
                nEnd = _hdmiInputs;
            
            cell.titleLabel.text = [NSString stringWithFormat:@"HDMI信号  %d ~ %d",nBegin,nEnd];
            cell.imageView.image = [UIImage imageNamed:@"signal_Card-Small.png"];
            [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath] ? YES : NO)];
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - Table view Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hdmiInputs <= GROUP_NUMBER)  // 小于等于16不进行分组
    {
        // 切换信号
        [_myDelegate haveSignal:SIGNAL_HDMI SwitchTo:(int)indexPath.row+1];
    }
    else                    // 分组需要展开
    {
        if (indexPath.row == 0)
        {
            if ([indexPath isEqual:self.selectIndex])
            {
                self.isOpen = NO;
                [self didSelectCellRowFirstDo:NO nextDo:NO];
                self.selectIndex = nil;
            }
            else
            {
                if (!self.selectIndex)
                {
                    self.selectIndex = indexPath;
                    [self didSelectCellRowFirstDo:YES nextDo:NO];
                }
                else
                {
                    [self didSelectCellRowFirstDo:NO nextDo:YES];
                }
            }
        }
        else
        {
            int nPath = (int)(indexPath.section*GROUP_NUMBER + indexPath.row);
            // 代理调用进行切换
            [_myDelegate haveSignal:SIGNAL_HDMI SwitchTo:nPath];
        }
    }
    
    // 选择状态恢复
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
