//
//  skySettingConnectionVC.m
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import "skySettingConnectionVC.h"

@interface skySettingConnectionVC ()

// 初始化视图组件
- (void)initializeComponents;
// 连接开关时间函数
- (void)connectionSwitchValueChanged;

@end

@implementation skySettingConnectionVC

@synthesize serverIP = _serverIP;
@synthesize serverPort = _serverPort;
@synthesize connectionSwitch = _connectionSwitch;
@synthesize myDelegate = _myDelegate;
@synthesize myDataSource = _myDataSource;

#pragma mark - skySettingConnectionVC Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 组件初始化
    [self initializeComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - skySettingConnectionVC Public Methods
// 控制器能否连接
- (void)controllerCanBeConnected:(BOOL)bFlag
{
    if (!bFlag)
    {
        NSLog(@"Can not Connect");
        [_connectionSwitch setOn:NO];
    }
}

#pragma mark - skySettingConnectionVC Private Methods
// 初始控制器组件
- (void)initializeComponents
{
    // 初始化IP输入控件
    _serverIP = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _serverIP.placeholder = @"172.16.16.119";
    _serverIP.text = [_myDataSource getCurrentIPAddress];
    _serverIP.textAlignment = NSTextAlignmentLeft;
    _serverIP.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _serverIP.keyboardAppearance = UIKeyboardTypeNumbersAndPunctuation;
    _serverIP.delegate = self;
    // 初始化端口输入控件
    _serverPort = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _serverPort.placeholder = @"5000";
    _serverPort.text = [NSString stringWithFormat:@"%d",[_myDataSource getCurrentPortNumber]];
    _serverPort.textAlignment = NSTextAlignmentLeft;
    _serverPort.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _serverPort.keyboardAppearance = UIKeyboardTypeNumberPad;
    _serverPort.delegate = self;
    // 初始化连接开关控件
    _connectionSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    _connectionSwitch.on = NO;
    [_connectionSwitch addTarget:self action:@selector(connectionSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
}

// 连接开关时间函数
- (void)connectionSwitchValueChanged
{
    if (_connectionSwitch.isOn)
    {
        // 连接控制器
        NSString *ipAddress = _serverIP.text;
        int nPort = [_serverPort.text intValue];
        
        // 设置控制器IP地址和端口号
        [_myDataSource setCurrentIPAddress:ipAddress andPort:nPort];
        // 连接控制器
        [_myDelegate connectToController:ipAddress andPort:nPort];
        
        NSLog(@"Connection On");
    }
    else
    {
        NSLog(@"Connection Off");
        
        // 断开控制器连接
        [_myDelegate disconnectController];
    }
}

#pragma mark - Table view data source
// Section Num
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

// 构建Cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"skySettingConnectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // 构造cell
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0: // ServerIp
                //cell.textLabel.text = @"服务器IP";
                cell.textLabel.text = NSLocalizedString(@"ConnectSet_IP", nil);
                _serverIP.text = [_myDataSource getCurrentIPAddress];
                cell.accessoryView = self.serverIP;
                _serverIP.textColor = [UIColor blueColor];
                break;
                
            case 1: // ServerPort
                //cell.textLabel.text = @"服务器端口";
                cell.textLabel.text = NSLocalizedString(@"ConnectSet_Port", nil);
                _serverPort.text = [[NSString alloc] initWithFormat:@"%d",[_myDataSource getCurrentPortNumber]];
                cell.accessoryView = self.serverPort;
                _serverPort.textColor = [UIColor blueColor];
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        //cell.textLabel.text = @"连接控制器";
        cell.textLabel.text = NSLocalizedString(@"ConnectSet_GetCon", nil);
        cell.accessoryView = _connectionSwitch;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = nil;
    
    if (section == 0)
    {
        //result = @"命令盒通信设置";
        result = NSLocalizedString(@"ConnectSet_Title", nil);
    }

    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *result = nil;
    
    if (section == 0)
    {
        //result = @"输入控制器IP地址、端口号";
        result = NSLocalizedString(@"ConnectSet_Info", nil);
    }
    
    return result;
}

#pragma mark - UITextFiled Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_serverIP resignFirstResponder];
    [_serverPort resignFirstResponder];
    return YES;
}

@end
