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
#import "SGToolbar.h"
#import "SGTabsView.h"
#import "SGTabView.h"
#import "SGTabDefines.h"


@interface SGTabsViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SGTabsView *tabsView;
@property (nonatomic, strong) SGToolbar *toolbar;

- (void)showViewController:(UIViewController *)viewController index:(NSUInteger)index;
- (void)removeViewController:(UIViewController *)viewController index:(NSUInteger)index;

@end

@implementation SGTabsViewController
@synthesize delegate;
@synthesize tabContents = _tabContents, currentViewController = _currentViewController;
@synthesize headerView = _headerView, tabsView = _tabsView, toolbar = _toolbar;
@synthesize contentFrame = _contentFrame;

- (id)init {
    if (self = [super initWithNibName:nil bundle:nil]) {
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGRect head = self.headerView.frame;
    CGRect bounds = self.view.bounds;
    _contentFrame = CGRectMake(bounds.origin.x,
                               bounds.origin.y + head.size.height,
                               bounds.size.width,
                               bounds.size.height - head.size.height);
    self.currentViewController.view.frame = self.contentFrame;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    CGRect bounds = self.view.bounds;
    
    CGRect head = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, kTabsToolbarHeigth + kTabsHeigth);
    self.headerView = [[UIView alloc] initWithFrame:head];
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CGRect frame = CGRectMake(head.origin.x, head.origin.y, head.size.width, kTabsToolbarHeigth);
    _toolbar = [[SGToolbar alloc] initWithFrame:frame];
    
    frame = CGRectMake(head.origin.x, kTabsToolbarHeigth, head.size.width, kTabsHeigth);
    _tabsView = [[SGTabsView alloc] initWithFrame:frame];
    _tabsView.tabsController = self;
    
    [self.headerView addSubview:_toolbar];
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

- (void)viewDidUnload {
    self.headerView = nil;
    self.toolbar = nil;
    self.tabsView = nil;
}

#pragma mark - Tab stuff

- (void)addTab:(UIViewController *)viewController {
    if ([self.delegate respondsToSelector:@selector(willShowTab:)]) {
        [self.delegate willShowTab:viewController];
    }
    
    if (![self.childViewControllers containsObject:viewController] && self.count < self.maxCount - 1) {
        [self addChildViewController:viewController];
        [self.tabContents addObject:viewController];
        viewController.view.frame = self.contentFrame;
        [viewController addObserver:self
                         forKeyPath:@"title"
                            options:NSKeyValueObservingOptionNew
                            context:NULL];
        
        
        // Add tab selects automatically the new tab
        [UIView transitionWithView:self.view
                          duration:kAddTabDuration
                           options:UIViewAnimationOptionAllowAnimatedContent
                        animations:^{
                            [self.tabsView addTab:viewController.title];
                            
                            if (self.currentViewController) {
                                [self.currentViewController viewWillDisappear:YES];
                                [self.currentViewController.view removeFromSuperview];
                                [self.currentViewController viewDidDisappear:YES];
                            }
                            _currentViewController = viewController;
                            [self.view addSubview:viewController.view];
                        }
                        completion:^(BOOL finished){
                            if (_toobarVisible)
                                [self.toolbar setItems:self.currentViewController.toolbarItems animated:YES];
                            [viewController didMoveToParentViewController:self];
                        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        NSUInteger index = [self.tabContents indexOfObject:object];
        SGTabView *tab = [self.tabsView.tabs objectAtIndex:index];
        [tab setTitle:[object title]];
        [tab setNeedsLayout];
    }
}

- (void)showViewController:(UIViewController *)viewController index:(NSUInteger)index {
    if (viewController == self.currentViewController 
        || ![self.tabContents containsObject:viewController]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(willShowTab:)]) {
        [self.delegate willShowTab:viewController];
    }
    
    if (_toobarVisible)
        [self.toolbar setItems:viewController.toolbarItems animated:YES];
    
    viewController.view.frame = self.contentFrame;
    [self transitionFromViewController:self.currentViewController
                      toViewController:viewController
                              duration:0
                               options:0
                            animations:^{
                                self.tabsView.selected = index;
                            }
                            completion:^(BOOL finished) {
                                _currentViewController = viewController;
                            }];
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
    NSUInteger oldIndex = index;
    
    [self.tabContents removeObjectAtIndex:oldIndex];
    [viewController removeObserver:self forKeyPath:@"title"];
    
    if (self.tabContents.count == 0) {//View controller was the last one
        [viewController willMoveToParentViewController:nil];
        _currentViewController = nil;
        [UIView transitionWithView:self.tabsView
                          duration:kRemoveTabDuration
                           options:UIViewAnimationOptionAllowAnimatedContent
                        animations:^{
                            [viewController viewWillDisappear:NO];
                            [viewController.view removeFromSuperview];
                            [viewController viewDidDisappear:NO];
                            [self.tabsView removeTab:index];
                            [self.toolbar setItems:nil animated:NO];
                        }
                        completion:^(BOOL finished){
                            [viewController removeFromParentViewController];
                        }];
        return;
    } else if (oldIndex >= self.tabContents.count) {
        index = self.tabContents.count-1;
    }
    
    UIViewController *to = [self.tabContents objectAtIndex:index];
    if (_toobarVisible)
        [self.toolbar setItems:to.toolbarItems animated:YES];
    
    [viewController willMoveToParentViewController:nil];
    [UIView transitionWithView:self.view
                      duration:kRemoveTabDuration
                       options:UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        [self.tabsView removeTab:oldIndex];
                        
                        if (self.currentViewController == viewController) {
                            [viewController viewWillDisappear:YES];
                            [viewController.view removeFromSuperview];
                            [viewController viewDidDisappear:YES];
                            
                            self.tabsView.selected = index;
                            to.view.frame = self.contentFrame;
                            [self.view addSubview:to.view];
                        }
                    }
                    completion:^(BOOL finished){
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
    _contentFrame.origin.y = head.size.height;
    
    [UIView animateWithDuration:animated ? 0.3 : 0 
                     animations:^{
                        self.currentViewController.view.frame = self.contentFrame;
                        self.headerView.frame = head;
                        self.toolbar.frame = toolbar;
                        self.tabsView.frame = tabs;
                     } completion: ^(BOOL finished){
                         _toobarVisible = !hidden;
                         if (_toobarVisible)
                             [self.toolbar setItems:self.currentViewController.toolbarItems animated:animated];
                         else
                             [self.toolbar setItems:nil animated:animated];
                     }];
}

- (BOOL)toolbarHidden {
    return !_toobarVisible;
}

#pragma mark - Propertys

- (NSUInteger)maxCount {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 7 : 4;
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

@end
