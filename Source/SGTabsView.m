//
//  SGTabsView.m
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

#import "SGTabsView.h"
#import "SGTabView.h"
#import "SGTabsViewController.h"
#import "SGTabDefines.h"

#define kMARGIN 2.5

@interface SGTabsView ()
- (CGFloat)tabWidth:(NSUInteger)count;
@end

@implementation SGTabsView
@synthesize tabs = _tabs, tabsController, selected = _selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin;
        self.autoresizesSubviews = YES;
    }
    return self;
}

- (NSMutableArray *)tabs {
    if (!_tabs) {
        _tabs = [[NSMutableArray alloc] initWithCapacity:[self.tabsController maxCount]];
    }
    return _tabs;
}

- (void)layoutSubviews{
    [self resizeTabs];
}

#pragma mark - Tab operations
- (void)addTab:(NSString *)title {
    CGFloat width = [self tabWidth:self.tabs.count+1];
    
    CGRect frame = CGRectMake(self.bounds.size.width, 0, width, self.bounds.size.height - kMARGIN);
    SGTabView *newTab = [[SGTabView alloc] initWithFrame:frame title:title];
    newTab.closeButton.hidden = !self.tabsController.editing;
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                           action:@selector(handleTap:)];
    tapG.numberOfTapsRequired = 1;
    tapG.numberOfTouchesRequired = 1;
    tapG.delegate = self;
    [newTab addGestureRecognizer:tapG];
    
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self 
                                                                           action:@selector(handlePan:)];
    panG.delegate = self;
    [newTab addGestureRecognizer:panG];
    
//    CGFloat cap = 7.5/width;
//    newTab.contentStretch = CGRectMake(cap, 0.0, 1.0, 1-cap);
    _selected = self.tabs.count;
    [self.tabs addObject:newTab];
    
    [self addSubview:newTab];
    for (int i = 0; i < self.tabs.count; i++) {
        SGTabView *tab = [self.tabs objectAtIndex:i];
        tab.frame = CGRectMake(width*i + kMARGIN, 0, width, self.bounds.size.height - kMARGIN);
        if (i == self.tabs.count-1) {
            tab.alpha = 1.0;
            [self bringSubviewToFront:tab];
        } else {
            tab.alpha = 0.7;
        }
        [tab setNeedsDisplay];
    }
}

- (void)removeTab:(NSUInteger)index {
    SGTabView *oldTab = [self.tabs objectAtIndex:index];
    if (oldTab) {
        [self.tabs removeObjectAtIndex:index]; 
        [oldTab removeFromSuperview];
        [self resizeTabs];
    }
}

- (void)setSelected:(NSUInteger)selected {
    _selected = selected;
    for (int i = 0; i < self.tabs.count; i++) {
        SGTabView *tab = [self.tabs objectAtIndex:i];
        if (i == selected) {
            tab.alpha = 1.0;
            [self bringSubviewToFront:tab];
        } else {
            tab.alpha = 0.7;
        }
        [tab setNeedsDisplay];
    }
}

#pragma mark - Helpers
- (CGFloat)tabWidth:(NSUInteger)count {
    CGFloat width;
    if (count > 0)
        width = (self.bounds.size.width - 2*kMARGIN)/count;
    else
        width = 360.0;
    return MIN(width, 360.0);
}


- (void)resizeTabs {
    CGFloat width = [self tabWidth:self.tabs.count];
    for (int i = 0; i < self.tabs.count; i++) {
        SGTabView *tab = [self.tabs objectAtIndex:i];
        tab.frame = CGRectMake(width*i + kMARGIN, 0, width, self.bounds.size.height - kMARGIN);
    }
}
                                    
#pragma mark - Gestures

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (void)handleTap:(UITapGestureRecognizer *)sender { 
    if (sender.state == UIGestureRecognizerStateEnded) {
        SGTabView *tab = (SGTabView *)sender.view;
        [self.tabsController showIndex:[self.tabs indexOfObject:tab]];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    SGTabView *panTab = (SGTabView *)sender.view;
    NSUInteger panPosition = [self.tabs indexOfObject:panTab];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.tabsController showIndex:panPosition];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint position = [sender translationInView:self];
        CGPoint center = CGPointMake(sender.view.center.x + position.x, sender.view.center.y);
        
        // Don't move the tab out of the view
        if (center.x < self.bounds.size.width - kMARGIN &&  center.x > kMARGIN) {
            sender.view.center = center;
            [sender setTranslation:CGPointZero inView:self];
            
            CGFloat width = [self tabWidth:self.tabs.count];
            // If more than half the tab width is moved, switch the positions
            if (abs(center.x - width*panPosition - width/2) > width/2) {
                NSUInteger nextPos = position.x > 0 ? panPosition+1 : panPosition-1;
                if (nextPos >= self.tabs.count)
                    return;
                
                SGTabView *next = [self.tabs objectAtIndex:nextPos];
                if (next) {
                    if (_selected == panPosition)
                        _selected = nextPos;
                    [self.tabs exchangeObjectAtIndex:panPosition withObjectAtIndex:nextPos];
                    [self.tabsController.tabContents exchangeObjectAtIndex:panPosition withObjectAtIndex:nextPos];
                    
                    [UIView animateWithDuration:0.5 animations:^{// Move the item on the old position of the panTab
                        next.frame = CGRectMake(width*panPosition + kMARGIN, 0, width, self.bounds.size.height - kMARGIN);
                    }];
                }
            }
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [sender velocityInView:self];
        [UIView animateWithDuration:0.5 animations:^{
            // Let's give it 0.025 secnonds more
            panTab.center = CGPointMake(panTab.center.x + velocity.x*0.025, panTab.center.y);
            [self resizeTabs];
        }];
    }
}

@end
