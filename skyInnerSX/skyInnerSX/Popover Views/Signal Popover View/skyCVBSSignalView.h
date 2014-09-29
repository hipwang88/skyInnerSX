//
//  skyCVBSSignalView.h
//  skyInnerSX
//
//  Created by skyworth on 14-9-29.
//  Copyright (c) 2014年 wziiy. All rights reserved.
//

#import <UIKit/UIKit.h>

// DataSource Protocol
@protocol skyCVBSSignalViewDataSource <NSObject>



@end

// Delegate Protocol
@protocol  skyCVBSSignalViewDelegate <NSObject>



@end

@interface skyCVBSSignalView : UITableViewController

//////////////////// Property ///////////////////////
@property (strong, nonatomic) id<skyCVBSSignalViewDelegate> myDelegate;
@property (strong, nonatomic) id<skyCVBSSignalViewDataSource> myDataSource;
//////////////////// Methods ////////////////////////

//////////////////// Ends ///////////////////////////

@end
