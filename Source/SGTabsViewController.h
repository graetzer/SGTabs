//
//  SGTabsViewController.h
//  SGTabs
//
//  Created by simon on 07.06.12.
//  Copyright (c) 2012 Cybercon GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SGTabsViewControllerDelegate <NSObject>

@optional
- (void)willShowTab:(NSUInteger)index;
- (void)willCloseTab:(NSUInteger)index;
- (UIViewController*)blankTabContent;

@end

@class SGTabsTopView, SGTabsView;

@interface SGTabsViewController : UIViewController {
    SGTabsTopView *_topView;
    SGTabsView *_tabsView;
}

@property (nonatomic, weak) id<SGTabsViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL editableTabs;

@property (nonatomic, strong) SGTabsView *tabsView;

/** Adds a blank tab
 * Reurns the id of the tab
 */
- (NSUInteger)addBlankTab:(NSString *)title;
- (void)addTabwithContent:(UIViewController *)viewController;

- (void)showTab:(NSUInteger)index;

- (NSUInteger)count;
- (NSUInteger)maxTabs;

@end
