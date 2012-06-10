//
//  SGTabsViewController.m
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

#import "SGTabsViewController.h"
#import "SGTabsTopView.h"
#import "SGTabsView.h"
#import "SGTabView.h"

#define kTabsTopViewHeigth 20.0
#define kTabsHeigth  30.0

@interface SGTabsViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SGTabsView *tabsView;
@property (nonatomic, strong) SGTabsTopView *topView;

- (void)showViewController:(UIViewController *)viewController index:(NSUInteger)index;
- (void)removeViewController:(UIViewController *)viewController index:(NSUInteger)index;

@end

@implementation SGTabsViewController
@synthesize delegate, editable = _editable;
@synthesize tabContents = _tabContents, currentViewController = _currentViewController;
@synthesize headerView = _headerView, tabsView = _tabsView, topView = _topView;

- (id)initEditable:(BOOL)editable {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _editable = editable;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _editable = NO;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.tabsView resizeTabs];
    CGRect head = self.headerView.frame;
    CGRect bounds = self.view.bounds;
    _contentFrame = CGRectMake(bounds.origin.x,
                               bounds.origin.y + head.size.height,
                               bounds.size.width,
                               bounds.size.height - head.size.height);
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    CGRect bounds = self.view.bounds;
    
    CGRect head = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, kTabsTopViewHeigth + kTabsHeigth);
    self.headerView = [[UIView alloc] initWithFrame:head];
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGRect frame = CGRectMake(head.origin.x, head.origin.y, head.size.width, kTabsTopViewHeigth);
    _topView = [[SGTabsTopView alloc] initWithFrame:frame];
    
    frame = CGRectMake(head.origin.x, kTabsTopViewHeigth, head.size.width, kTabsHeigth);
    _tabsView = [[SGTabsView alloc] initWithFrame:frame];
    _tabsView.tabsController = self;
    
    [self.headerView addSubview:_topView];
    [self.headerView addSubview:_tabsView];
    [self.view addSubview:self.headerView];
    
    _contentFrame = CGRectMake(bounds.origin.x,
                               bounds.origin.y + head.size.height,
                               bounds.size.width,
                               bounds.size.height - head.size.height);
}

- (UIView *)rotatingHeaderView {
    return self.headerView;
}

#pragma mark - Tab stuff

- (void)addTab:(UIViewController *)viewController {
    if ([self.delegate respondsToSelector:@selector(willShowTab:)]) {
        [self.delegate willShowTab:viewController];
    }
    
    if (![self.childViewControllers containsObject:viewController] && self.count < self.maxCount - 1) {
        [self addChildViewController:viewController];
        viewController.view.frame = _contentFrame;
        
        // Add tab selects automatically the new tab
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            [self.tabsView addTab:viewController.title];
                            
                            if (self.currentViewController) {
                                [self.currentViewController viewWillDisappear:YES];
                                [self.currentViewController.view removeFromSuperview];
                                [self.currentViewController viewDidDisappear:YES];
                            }
                            
                            [self.view addSubview:viewController.view];
                        }
                        completion:^(BOOL finished){
                            [viewController didMoveToParentViewController:self];
                            _currentViewController = viewController;
                        }];
    }
}


- (void)showViewController:(UIViewController *)viewController index:(NSUInteger)index {
    if (viewController == self.currentViewController) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(willShowTab:)]) {
        [self.delegate willShowTab:viewController];
    }
    
    self.tabsView.selected = index;
    [self transitionFromViewController:self.currentViewController
                      toViewController:viewController
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                viewController.view.frame = _contentFrame;
                            }
                            completion:^(BOOL finished) {
                                _currentViewController = viewController;
                            }];
    _currentViewController = viewController;
}

- (void)showIndex:(NSUInteger)index; {
    UIViewController *viewController = [self.tabContents objectAtIndex:index];
    [self showViewController:viewController index:index];
}

- (void)showViewController:(UIViewController *)viewController {
    NSUInteger index = [self.tabContents indexOfObject:viewController];
    [self showViewController:viewController index:index];
}

- (void)removeViewController:(UIViewController *)viewController index:(NSUInteger)index {
    if ([self.delegate respondsToSelector:@selector(willRemoveTab:)]) {
        [self.delegate willRemoveTab:viewController];
    }
    
    [self.tabsView removeTab:index];
    if (index < self.count - 1)
        index++;
    else if (index > 0)
        index--;
    else {
        [viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
        _currentViewController = nil;
        return;
    }
    
    self.tabsView.selected = index;
    UIViewController *to = [self.tabContents objectAtIndex:index];
    
    [viewController willMoveToParentViewController:nil];
    [self transitionFromViewController:viewController
                      toViewController:to
                              duration: viewController == self.currentViewController ? 0.5 : 0
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                to.view.frame = _contentFrame;
                            }
                            completion:^(BOOL finished) {
                                [viewController removeFromParentViewController];
                                _currentViewController = to;
                            }];

}

- (void)removeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.tabContents indexOfObject:viewController];
    [self removeViewController:viewController index:index];
}

- (void)removeIndex:(NSUInteger)index {
    UIViewController *viewController = [self.tabContents objectAtIndex:index];
    [self removeViewController:viewController index:index];
}

#pragma mark - Propertys

- (NSUInteger)maxCount {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6 : 3;
}

- (NSUInteger)count {
    return self.tabsView.tabs.count;
}

- (NSMutableArray *)tabContents {
    if (!_tabContents) {
        _tabContents = [[NSMutableArray alloc] initWithCapacity:self.maxCount];
    }
    return _tabContents;
}
         
- (void)addChildViewController:(UIViewController *)childController {
    [self.tabContents addObject:childController];
    [super addChildViewController:childController];
}

@end
