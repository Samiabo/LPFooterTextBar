//
//  LPFooterTextItem.h
//  LPFooterTextBarDemo
//
//  Created by XuYafei on 16/2/22.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat defaultEdgeInsets = 5;

@interface LPFooterTextItem : NSObject

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat width;

- (instancetype)initWithButton:(UIButton *)button;

@end
