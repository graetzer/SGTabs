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
#import <math.h>

#define kRadius 10.0
#define kMargin 2*kRadius


@implementation SGTabView
@synthesize titleLabel, editable, closeButton;

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
        topColor = [[UIColor alloc] initWithWhite:0.9 alpha:1];
        bottomColor = [[UIColor alloc] initWithWhite:0.8 alpha:1];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.closeButton setImage:[UIImage imageNamed:@"button_close"]
//                          forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    CGRect inner = [self tabRect];
    self.titleLabel.frame = inner;
    CGSize size = self.closeButton.frame.size;
    self.closeButton.center = CGPointMake(inner.size.width - size.width,
                                          inner.size.height/2);
}

- (void)drawRect:(CGRect)rect {
    CGRect  tabRect   = self.bounds;
    CGFloat tabLeft   = tabRect.origin.x;
    CGFloat tabRight  = tabRect.origin.x + tabRect.size.width;
    CGFloat tabTop    = tabRect.origin.y;
    CGFloat tabBottom = tabRect.origin.y + tabRect.size.height + 0.5;
    
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    
    [bPath moveToPoint:CGPointMake(tabLeft, tabTop)];
    // Top left
    [bPath addArcWithCenter:CGPointMake(tabLeft, tabTop + kRadius) radius:kRadius startAngle:3*M_PI_2 endAngle:0 clockwise:YES];
    
    [bPath addLineToPoint:CGPointMake(tabLeft + kRadius, tabBottom - kRadius)];
    // Bottom left
    [bPath addArcWithCenter:CGPointMake(tabLeft + 2*kRadius, tabBottom - kRadius) radius:kRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    
    [bPath addLineToPoint:CGPointMake(tabRight - 2*kRadius, tabBottom)];
    // Bottom rigth
    [bPath addArcWithCenter:CGPointMake(tabRight - 2*kRadius, tabBottom - kRadius) radius:kRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
    
    [bPath addLineToPoint:CGPointMake(tabRight - kRadius, tabTop + kRadius)];
    // Top rigth
    [bPath addArcWithCenter:CGPointMake(tabRight, tabTop + kRadius) radius:kRadius startAngle:M_PI endAngle:3*M_PI_2 clockwise:YES];
    
    [bPath addLineToPoint:CGPointMake(tabRight, tabTop)];
    [bPath closePath];
    
    CGPathRef path = [bPath CGPath];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Fill with current tab color
    CGColorRef startColor = [topColor CGColor];
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, startColor);
    CGContextSetShadow(context, CGSizeMake(0, 5), 3.0);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    // Render the interior of the tab path using the gradient.
    
    // Configure a linear gradient which adds a simple white highlight on the top.
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 0.5 };
    
    
    CGColorRef endColor = [bottomColor CGColor];
    
    const void* colors[] = {startColor, endColor};
    
    CFArrayRef colorArray = CFArrayCreate(NULL, colors, 2, &kCFTypeArrayCallBacks);    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorArray, locations);
    CFRelease(colorArray);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(tabRect), tabRect.origin.y);
    CGPoint endPoint   = CGPointMake(CGRectGetMidX(tabRect), tabRect.origin.y + tabRect.size.height);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end