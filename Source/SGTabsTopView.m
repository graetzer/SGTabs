//
//  SGTabTopView.m
//  SGTabs
//
//  Created by simon on 07.06.12.
//  Copyright (c) 2012 Cybercon GmbH. All rights reserved.
//

#import "SGTabsTopView.h"

@implementation SGTabsTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat shadowRadius = 3.0;
    
    // We don't want to see the shadow anywhere but above the top edge.
    // But the shadow only looks good when we _fill_ a path so we just
    // use a rect whose left/right/bottom aren't visible.
    
    CGFloat bigValue = 1e6;
    
    CGRect r = CGRectMake(-bigValue, shadowRadius - 0.5,
                          self.frame.size.width + bigValue, bigValue);
    
    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeZero, shadowRadius);
    CGContextSetFillColorWithColor(context, [[UIColor alloc] initWithWhite:0.9 alpha:1].CGColor);
    CGContextFillRect(context, r);
    CGContextRestoreGState(context);
}

@end
