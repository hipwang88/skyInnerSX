//
//  skyVGASignalView.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-29.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// DataSource Protocol
@protocol skyVGASignalViewDataSource <NSObject>



@end

// Delegate Protocol
@protocol  skyVGASignalViewDelegate <NSObject>



@end

@interface skyVGASignalView : UITableViewController

//////////////////// Property ///////////////////////
@property (strong, nonatomic) id<skyVGASignalViewDelegate> myDelegate;
@property (strong, nonatomic) id<skyVGASignalViewDataSource> myDataSource;
//////////////////// Methods ////////////////////////

//////////////////// Ends ///////////////////////////

@end

