//
//  LPFooterTextItem.m
//  LPFooterTextBarDemo
//
//  Created by XuYafei on 16/2/22.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPFooterTextItem.h"

@implementation LPFooterTextItem

- (instancetype)initWithButton:(UIButton *)button {
    self = [super init];
    if (self) {
        _button = button;
        _width = 44;
        _edgeInsets = UIEdgeInsetsMake(0, defaultEdgeInsets / 2,
                                       0, defaultEdgeInsets / 2);
    }
    return self;
}

- (instancetype)init {
    return [self initWithButton:[UIButton new]];
}

@end
