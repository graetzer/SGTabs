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
#import "SGTabsToolbar.h"
#import "SGTabsView.h"
#import "SGTabView.h"
#import "SGTabDefines.h"

@interface SGTabsViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SGTabsView *tabsView;
@property (nonatomic, strong) SGTabsToolbar *toolbar;


- (void)showViewController:(UIViewController *)viewController index:(NSUInteger)index;
- (void)removeViewController:(UIViewController *)viewController index:(NSUInteger)index;
- (CGRect)contentFrame;

@end

@implementation SGTabsViewController {
    BOOL _toobarVisible;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIView *)rotatingHeaderView {
    return self.headerView;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    CGRect bounds = self.view.bounds;
    
    CGRect head = CGRectMake(0, 0, bounds.size.width, kTabsToolbarHeigth + kTabsHeigth);
    self.headerView = [[UIView alloc] initWithFrame:head];
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.headerView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = CGRectMake(0, 0, head.size.width, kTabsToolbarHeigth);
    _toolbar = [[SGTabsToolbar alloc] initWithFrame:frame];
    
    frame = CGRectMake(0, kTabsToolbarHeigth, head.size.width, kTabsHeigth);
    _tabsView = [[SGTabsView alloc] initWithFrame:frame];
    
    [self.headerView addSubview:_tabsView];
    [self.headerView addSubview:_toolbar];
     
    [self.view addSubview:self.headerView];
}

- (void)viewDidLoad {
    self.tabsView.tabsController = self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.headerView = nil;
    self.toolbar = nil;
    self.tabsView = nil;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.selectedViewController.view.frame = [self contentFrame];
}

#pragma mark - Tab stuff

- (void)addViewController:(UIViewController *)childController {
    if ([self.childViewControllers containsObject:childController] || self.count > self.maxCount)
        return;
    
    [self addChildViewController:childController];
    
    if (self.tabsView.tabs.count == 0) {
        if ([self.delegate respondsToSelector:@selector(willShowTab:)])
            [self.delegate willShowTab:childController];
        if (_toobarVisible)
            [self.toolbar setItems:childController.toolbarItems animated:YES];
        
        [childController.view setNeedsLayout];
        [self.tabsView addTab:childController];
        [self.view addSubview:childController.view];
        self.tabsView.selected = 0;
        [childController didMoveToParentViewController:self];
        return;
    }
    
    [UIView animateWithDuration:kAddTabDuration
                     animations:^{
                         [self.tabsView addTab:childController];
                     }
                     completion:^(BOOL finished){
                         [childController didMoveToParentViewController:self];
                         self.tabsView.selected = self.selectedIndex;
                     }];
}

- (void)showViewController:(UIViewController *)viewController index:(NSUInteger)index {
    UIViewController *current = [self selectedViewController];
    if (viewController == current || [self.tabsView indexOfViewController:viewController] == NSNotFound)
        return;
    
    if ([self.delegate respondsToSelector:@selector(willShowTab:)])
        [self.delegate willShowTab:viewController];
    
    [self transitionFromViewController:current
                      toViewController:viewController
                              duration:0
                               options:0
                            animations:^{
                                if (_toobarVisible)
                                    [self.toolbar setItems:viewController.toolbarItems animated:YES];
                                self.tabsView.selected = index;
                            }
                            completion:NULL];
}

- (void)showIndex:(NSUInteger)index; {
    [self showViewController:[self.tabsView viewControllerAtIndex:index] index:index];
}

- (void)showViewController:(UIViewController *)viewController {
    [self showViewController:viewController index:[self.tabsView indexOfViewController:viewController]];
}

- (void)removeViewController:(UIViewController *)viewController index:(NSUInteger)index {
    if ([self.delegate respondsToSelector:@selector(willRemoveTab:)])
        [self.delegate willRemoveTab:viewController];
    
    [viewController willMoveToParentViewController:nil];
    if (self.count == 1) {
        [viewController.view removeFromSuperview];
        [self.tabsView removeTab:index];
        [self.toolbar setItems:nil animated:YES];
        [viewController removeFromParentViewController];
        return;
    }
    
    NSUInteger newIndex = index;
    UIViewController *to;
    if (index == self.tabsView.tabs.count - 1) {
        newIndex--;
        to = [self.tabsView viewControllerAtIndex:newIndex];
    } else
        to  = [self.tabsView viewControllerAtIndex:newIndex+1];
    
    if (_toobarVisible)
        [self.toolbar setItems:to.toolbarItems animated:YES];
    
    [self transitionFromViewController:viewController
                      toViewController:to
                              duration:kRemoveTabDuration 
                               options:UIViewAnimationOptionAllowAnimatedContent
                            animations:^{
                                [self.tabsView removeTab:index];
                                self.tabsView.selected = newIndex;
                            }
                            completion:^(BOOL finished){
                                [viewController removeFromParentViewController];
                            }];
}

- (void)removeViewController:(UIViewController *)viewController {
    [self removeViewController:viewController index:[self.tabsView indexOfViewController:viewController]];
}

- (void)removeIndex:(NSUInteger)index {
    [self removeViewController:[self.tabsView viewControllerAtIndex:index] index:index];
}

- (void)swapCurrentViewControllerWith:(UIViewController *)viewController {
    UIViewController *old = [self selectedViewController];
    
    if (!old)
        [self addViewController:viewController];
    else if (![self.childViewControllers containsObject:viewController]) {
        [self addChildViewController:viewController];
        NSUInteger index = [self selectedIndex];
        
        [old willMoveToParentViewController:nil];
        [self transitionFromViewController:old
                          toViewController:viewController 
                                  duration:0 
                                   options:UIViewAnimationOptionAllowAnimatedContent
                                animations:NULL
                                completion:^(BOOL finished){
                                    [old removeFromParentViewController];
                                    
                                    // Update tab content
                                    SGTabView *tab = (self.tabsView.tabs)[index];
                                    tab.viewController = viewController;
                                    if ([viewController respondsToSelector:@selector(canRemoveTab)])
                                        tab.closeButton.hidden = !(BOOL)[viewController performSelector:@selector(canRemoveTab)];
                                    else
                                        tab.closeButton.hidden = NO;
                                    
                                    [viewController didMoveToParentViewController:self];
                                }];
    }
}

#pragma mark - Stuff
- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (_toobarVisible != hidden)
        return;
    
    CGRect head = self.headerView.frame;
    CGRect toolbar = self.toolbar.frame;
    CGRect tabs = self.tabsView.frame;
    
    CGFloat toolbarHeight = hidden ? kTabsToolbarHeigth : kTabsToolbarHeigthFull;
    head.size.height = toolbarHeight+kTabsHeigth;
    toolbar.size.height = toolbarHeight;
    tabs.origin.y = toolbarHeight;
    
    [UIView animateWithDuration:animated ? 0.3 : 0
                     animations:^{
                         self.headerView.frame = head;
                         self.toolbar.frame = toolbar;
                         self.tabsView.frame = tabs;
                     } completion: ^(BOOL finished){
                         _toobarVisible = !hidden;
                         if (_toobarVisible)
                             [self.toolbar setItems:self.selectedViewController.toolbarItems animated:animated];
                         else
                             [self.toolbar setItems:nil animated:animated];
                     }];
}

- (BOOL)toolbarHidden {
    return !_toobarVisible;
}

- (CGRect)contentFrame {
    CGRect head = self.headerView.frame;
    CGRect bounds = self.view.bounds;
    return CGRectMake(bounds.origin.x,
                      bounds.origin.y + head.size.height,
                      bounds.size.width,
                      bounds.size.height - head.size.height);
}

- (UIViewController *)selectedViewController {
    return self.count > 0 ? [self.tabsView viewControllerAtIndex:self.tabsView.selected] : nil;
}

- (NSUInteger)selectedIndex {
    return self.tabsView.selected;
}

- (NSUInteger)maxCount {
    return 10;
}

- (NSUInteger)count {
    return self.tabsView.tabs.count;
}

@end
