//
//  SGTabView.m
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

#import "SGTabView.h"
#import "SGTabDefines.h"

#import <math.h>




@implementation SGTabView
@synthesize titleLabel, closeButton;
@synthesize tabColor;

- (CGRect)tabRect {
    return CGRectMake(self.bounds.origin.x,
                      self.bounds.origin.y,
                      self.bounds.size.width,
                      self.bounds.size.height);
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = UIViewAutoresizingFlexibleWidth;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
        self.titleLabel.shadowOffset = CGSizeMake(0, 0.5);
        [self addSubview:self.titleLabel];
        
//        self.closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [self.closeButton setTitle:@"Hello" forState:UIControlStateNormal];
//        [self.closeButton setImage:[UIImage imageNamed:@"cross.png"]
//                          forState:UIControlStateNormal];
        [self  addSubview:self.closeButton];
        
        self.tabColor = kTabColor;
    }
    return self;
}

- (void)layoutSubviews {
    CGRect inner = [self tabRect];
    self.titleLabel.frame = inner;
//    inner.origin.x -= 10;
//    inner.size.width -=10;
//    self.closeButton.frame = inner;
}

- (void)drawRect:(CGRect)rect {
    CGRect  tabRect   = self.bounds;
    CGFloat tabLeft   = tabRect.origin.x;
    CGFloat tabRight  = tabRect.origin.x + tabRect.size.width;
    CGFloat tabTop    = tabRect.origin.y;
    CGFloat tabBottom = tabRect.origin.y + tabRect.size.height;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, tabLeft, tabTop);
    // Top left
    CGPathAddArc(path, NULL, tabLeft, tabTop + kCornerRadius, kCornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, tabLeft + kCornerRadius, tabBottom - kCornerRadius);
    
    // Bottom left
    CGPathAddArc(path, NULL, tabLeft + 2*kCornerRadius, tabBottom - kCornerRadius, kCornerRadius, M_PI, M_PI_2, YES);
    CGPathAddLineToPoint(path, NULL, tabRight - 2*kCornerRadius, tabBottom);
    
    // Bottom rigth
    CGPathAddArc(path, NULL, tabRight - 2*kCornerRadius, tabBottom - kCornerRadius, kCornerRadius, M_PI_2, 0, YES);
    CGPathAddLineToPoint(path, NULL, tabRight - kCornerRadius, tabTop + kCornerRadius);
    
    // Top rigth
    CGPathAddArc(path, NULL, tabRight, tabTop + kCornerRadius, kCornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, tabRight, tabTop);
    CGPathCloseSubpath(path);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Fill with current tab color
    CGColorRef startColor = [self.tabColor CGColor];
    
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, path);
    CGContextSetFillColorWithColor(ctx, startColor);
    CGContextSetShadow(ctx, CGSizeMake(0, -1), kShadowRadius);
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
    
}

@end
