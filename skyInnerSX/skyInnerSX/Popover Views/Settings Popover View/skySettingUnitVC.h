//
//  skySettingUnitVC.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skyPopBaseViewController.h"
#import "skyUnitSelectionVC.h"

// Delegate Protocol
@protocol skySettingUnitVCDelegate <NSObject>



@end

// DataSource Protocol
@protocol skySettingUnitVCDataSource <NSObject>



@end

// class skySettingUnitVC
@interface skySettingUnitVC : skyPopBaseViewController<UITableViewDelegate,UITableViewDataSource>

//////////////////////// Property /////////////////////////////
@property (strong, nonatomic) IBOutlet UITableView *myTableView;                // Table View对象
@property (strong, nonatomic) UISwitch *useKeyboardSwitch;                      // 虚拟键盘使用开关
@property (strong, nonatomic) id<skySettingUnitVCDelegate> myDelegate;          // 代理对象
@property (strong, nonatomic) id<skySettingUnitVCDataSource> myDataSource;      // 数据源对象
@property (strong, nonatomic) skyUnitSelectionVC *selectionView;                // 单元选择视图

//////////////////////// Methods //////////////////////////////

//////////////////////// Ends /////////////////////////////////

@end
