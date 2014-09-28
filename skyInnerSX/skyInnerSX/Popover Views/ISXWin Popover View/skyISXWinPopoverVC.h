//
//  skyISXWinPopoverVC.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-23.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "skySignalViewController.h"

@protocol skyISXWinPopoverVCDelegate <NSObject>



@end

@interface skyISXWinPopoverVC : UITableViewController

////////////////////// Property ///////////////////////////
@property (strong, nonatomic) skySignalViewController *signalView;
@property (strong, nonatomic) id<skyISXWinPopoverVCDelegate> myDelegate;

////////////////////// Methods ////////////////////////////

////////////////////// Ends ///////////////////////////////

@end
