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

#define kTabsTopViewHeigth 10.0
#define kTabsTopViewHeigthFull 44.0
#define kTabsHeigth  30.0

@interface SGTabsViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SGTabsView *tabsView;
@property (nonatomic, strong) SGToolbar *toolbar;

- (void)showViewController:(UIViewController *)viewController index:(NSUInteger)index;
- (void)removeViewController:(UIViewController *)viewController index:(NSUInteger)index;

@end

@implementation SGTabsViewController
@synthesize delegate, editable = _editable;
@synthesize tabContents = _tabContents, currentViewController = _currentViewController;
@synthesize headerView = _headerView, tabsView = _tabsView, toolbar = _toolbar;

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
    _toolbar = [[SGToolbar alloc] initWithFrame:frame];
    
    frame = CGRectMake(head.origin.x, kTabsTopViewHeigth, head.size.width, kTabsHeigth);
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
                           options:UIViewAnimationOptionAllowAnimatedContent
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
    if (viewController == self.currentViewController 
        || ![self.tabContents containsObject:viewController]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(willShowTab:)]) {
        [self.delegate willShowTab:viewController];
    }
    self.tabsView.selected = index;
    
    [self transitionFromViewController:self.currentViewController
                      toViewController:viewController
                              duration:0
                               options:UIViewAnimationOptionAllowAnimatedContent
                            animations:^{
                                
                                viewController.view.frame = _contentFrame;
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
    
    if (self.currentViewController == viewController) {
        if (index < self.count - 1)
            index++;
        else if (index > 0)
            index--;
        else {// View controller is the last one
            [viewController willMoveToParentViewController:nil];
            [viewController viewWillDisappear:NO];
            [viewController.view removeFromSuperview];
            [viewController viewDidDisappear:NO];
            [viewController removeFromParentViewController];
            _currentViewController = nil;
            return;
        }
    }
    
    UIViewController *to = [self.tabContents objectAtIndex:index];
    [self.tabContents removeObjectAtIndex:index];
    
    [viewController willMoveToParentViewController:nil];
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [self.tabsView removeTab:index];
                        to.view.frame = _contentFrame;
                        
                        if (self.currentViewController == viewController) {
                            [viewController viewWillDisappear:YES];
                            [viewController.view removeFromSuperview];
                            [viewController viewDidDisappear:YES];
                            self.tabsView.selected = index;
                            to.view.frame = _contentFrame;
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
    if (_toobarVisible != hidden) {
        return;
    }
    _toobarVisible = !hidden;
    
    CGRect head = self.headerView.frame;
    CGRect toolbar = self.toolbar.frame;
    CGRect tabs = self.tabsView.frame;
    
    CGFloat toolbarHeight = hidden ? kTabsTopViewHeigth : kTabsTopViewHeigthFull; 
    head.size.height = toolbarHeight+kTabsHeigth;
    toolbar.size.height = toolbarHeight;
    tabs.origin.y = toolbarHeight;
    _contentFrame.origin.y = head.size.height;
    
    [UIView animateWithDuration:animated ? 0.3 : 0 
                     animations:^{
                        self.currentViewController.view.frame = _contentFrame;
                        self.headerView.frame = head;
                        self.toolbar.frame = toolbar;
                        self.tabsView.frame = tabs;
    }];
}

- (BOOL)toolbarHidden {
    return !_toobarVisible;
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
