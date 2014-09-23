//
//  skySettingConfigVC.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyPopBaseViewController.h"

// DataSource Protocol
@protocol skySettingConfigVCDataSource <NSObject>

// 获取当前拼接行数
- (NSInteger)getCurrentScreenRow;
// 获取当前拼接列数
- (NSInteger)getCurrentScreenColumn;
// 设置当前行列数
- (void)setCurrentScreenRow:(NSInteger)nRow andColumn:(NSInteger)nColumn;

@end

// Delegate Protocol
@protocol skySettingConfigVCDelegate <NSObject>

// 设定行列数
- (void)setScreenRow:(NSInteger)nRow andColumn:(NSInteger)nColumn;

@end

// class skySettingConfigVC
@interface skySettingConfigVC : skyPopBaseViewController<UITableViewDelegate,UITableViewDataSource>

//////////////////////// Property /////////////////////////////
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) id<skySettingConfigVCDelegate> myDelegate;
@property (strong, nonatomic) id<skySettingConfigVCDataSource> myDataSource;
//////////////////////// Methods //////////////////////////////

//////////////////////// Ends /////////////////////////////////

@end
