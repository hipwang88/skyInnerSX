//
//  skyHDMISignalView.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-29.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// DataSource Protocol
@protocol skyHDMISignalViewDataSource <NSObject>



@end

// Delegate Protocol
@protocol  skyHDMISignalViewDelegate <NSObject>



@end

@interface skyHDMISignalView : UITableViewController

//////////////////// Property ///////////////////////
@property (strong, nonatomic) id<skyHDMISignalViewDelegate> myDelegate;
@property (strong, nonatomic) id<skyHDMISignalViewDataSource> myDataSource;
//////////////////// Methods ////////////////////////

//////////////////// Ends ///////////////////////////

@end

