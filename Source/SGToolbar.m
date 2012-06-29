//
//  SGTabTopView.m
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

#import "SGToolbar.h"
#import "SGTabDefines.h"

@implementation SGToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _bottomColor = kTabColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
    CGPoint bottomCenter = CGPointMake(CGRectGetMidX(self.bounds), self.bounds.size.height);
    CGFloat locations[2] = { 0.00, 0.90};
    
    CGFloat redEnd, greenEnd, blueEnd, alphaEnd;
    [_bottomColor getRed:&redEnd green:&greenEnd blue:&blueEnd alpha:&alphaEnd];
    //Two colour components, the start and end colour both set to opaque. Red Green Blue Alpha
    CGFloat components[8] = { 244./255., 245./255., 247./255., 1.0, redEnd, greenEnd, blueEnd, 1.0};
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
    CGContextDrawLinearGradient(context, gradient, topCenter, bottomCenter, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
}

@end
