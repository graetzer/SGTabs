//
//  SGTabsView.m
//  SGTabs
//
//  Created by simon on 07.06.12.
//  Copyright (c) 2012 Cybercon GmbH. All rights reserved.
//

#import "SGTabsView.h"
#import "SGTabView.h"
#import "SGTabsViewController.h"

#define MARGIN 2.5

@interface SGTabsView ()
- (CGFloat)tabWidth:(NSUInteger)count;
@end

@implementation SGTabsView
@synthesize tabs = _tabs, tabsController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin;
        self.autoresizesSubviews = YES;
    }
    return self;
}

- (CGFloat)tabWidth:(NSUInteger)count {
    CGFloat width;
    if (count > 0)
        width = (self.bounds.size.width - 2*MARGIN)/count;
    else
        width = 300.0;
    return MIN(width, 300.0);
}

- (NSMutableArray *)tabs {
    if (!_tabs) {
        _tabs = [[NSMutableArray alloc] initWithCapacity:[self.tabsController maxTabs]];
    }
    return _tabs;
}

- (void)addTab:(NSString *)title {
    CGFloat width = [self tabWidth:self.tabs.count+1];
    
    CGRect frame = CGRectMake(self.bounds.size.width, 0, width, self.bounds.size.height - MARGIN);
    SGTabView *newTab = [[SGTabView alloc] initWithFrame:frame title:title];
    newTab.editable = self.tabsController.editableTabs;
    CGFloat cap = 5.0/width;
    newTab.contentStretch = CGRectMake(cap, 0.0, 1.0, 1-cap);
    [self.tabs addObject:newTab];
    
    [UIView transitionWithView:self
                      duration:0.5
                       options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        
                        [self addSubview:newTab];
                        
                        for (int i = 0; i < self.tabs.count; i++) {
                            SGTabView *tab = [self.tabs objectAtIndex:i];
                            tab.frame = CGRectMake(width*i + MARGIN, 0, width, self.bounds.size.height - MARGIN);
                        }
                        
                    } 
                    completion:NULL];
}

- (void)resizeTabs {
    CGFloat width = [self tabWidth:self.tabs.count];
    for (int i = 0; i < self.tabs.count; i++) {
        SGTabView *tab = [self.tabs objectAtIndex:i];
        tab.frame = CGRectMake(width*i + MARGIN, 0, width, self.bounds.size.height - MARGIN);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
