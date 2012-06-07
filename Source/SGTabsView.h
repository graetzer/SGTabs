//
//  SGTabsView.h
//  SGTabs
//
//  Created by simon on 07.06.12.
//  Copyright (c) 2012 Cybercon GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGTabsViewController;

@interface SGTabsView : UIView

@property (nonatomic, weak) SGTabsViewController *tabsController; 
@property (nonatomic, strong) NSMutableArray *tabs;

- (void)addTab:(NSString *)title;

/// Calculates the width each tabs needs and resizes the view
- (void)resizeTabs;
@end
