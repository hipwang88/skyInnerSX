//
//  skySignalViewController.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol skySignalViewControllerDataSource <NSObject>



@end

@protocol skySignalViewControllerDelegate <NSObject>



@end

@interface skySignalViewController : UITableViewController

@property (strong, nonatomic) id<skySignalViewControllerDelegate> myDelegate;
@property (strong, nonatomic) id<skySignalViewControllerDataSource> myDataSource;

// 初始化
- (void)initialSignalTable;

@end
