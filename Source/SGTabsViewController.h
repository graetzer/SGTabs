//
//  SGTabsViewController.h
//  SGTabs
//
//  Created by simon on 07.06.12.
//
//
//  Copyright (c) 2012 Simon Grätzer
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <UIKit/UIKit.h>

@protocol SGTabsViewControllerDelegate <NSObject>
@optional
- (void)willShowTab:(UIViewController *)viewController;
- (void)willRemoveTab:(UIViewController *)viewController;
@end
@protocol SGTabsChildViewController <NSObject>

- (BOOL)canRemoveTab;

@end

@class SGTabsToolbar, SGTabsView;

@interface SGTabsViewController : UIViewController

/// An optional delegate
@property (nonatomic, weak) id<SGTabsViewControllerDelegate> delegate;

/// Adds a tab, don't add the same instance twice!
- (void)addViewController:(UIViewController *)childController;
/// Bring a tab to the frontpage
- (void)showViewController:(UIViewController *)viewController;
/// Remove a tap
- (void)removeViewController:(UIViewController *)childController;

/// Remove tab at index
- (void)removeIndex:(NSUInteger)index;

// Swap the current view controller.
- (void)swapCurrentViewControllerWith:(UIViewController *)viewController;

/// Primarily intended for internal use
- (void)showIndex:(NSUInteger)index;

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
- (BOOL)toolbarHidden;

- (UIViewController *)selectedViewController;
- (NSUInteger)selectedIndex;
- (NSUInteger)count;
- (NSUInteger)maxCount;
@end
