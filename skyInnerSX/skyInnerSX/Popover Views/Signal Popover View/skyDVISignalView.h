//
//  skyDVISignalView.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-29.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// DataSource Protocol
@protocol skyDVISignalViewDataSource <NSObject>



@end

// Delegate Protocol
@protocol  skyDVISignalViewDelegate <NSObject>



@end

@interface skyDVISignalView : UITableViewController

//////////////////// Property ///////////////////////
@property (strong, nonatomic) id<skyDVISignalViewDelegate> myDelegate;
@property (strong, nonatomic) id<skyDVISignalViewDataSource> myDataSource;
//////////////////// Methods ////////////////////////

//////////////////// Ends ///////////////////////////

@end

