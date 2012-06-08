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
- (void)willShowTab:(NSUInteger)index;
- (void)willCloseTab:(NSUInteger)index;
- (UIViewController*)blankTabContent;

@end

@class SGTabsTopView, SGTabsView;

@interface SGTabsViewController : UIViewController {
    SGTabsTopView *_topView;
    SGTabsView *_tabsView;
    BOOL _editable;
}

@property (nonatomic, weak) id<SGTabsViewControllerDelegate> delegate;
@property (nonatomic, readonly) BOOL editable;

@property (nonatomic, strong) SGTabsView *tabsView;

- (id)initEditable:(BOOL)editable;

/** Adds a blank tab
 * Reurns the id of the tab
 */
- (NSUInteger)addBlankTab:(NSString *)title;
- (void)addTabwithContent:(UIViewController *)viewController;

- (void)showTab:(NSUInteger)index;

- (void)removeTab:(NSUInteger)index;

- (NSUInteger)count;
- (NSUInteger)maxTabs;

@end
