//
//  SGTabView.h
//  SGTabs
//
//  Created by simon on 07.06.12.
//  Copyright (c) 2012 Cybercon GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGTabView : UIView {
    UIColor *topColor;
    UIColor *bottomColor;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) BOOL editable;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
