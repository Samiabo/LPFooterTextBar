//
//  LPTextView.h
//  LPFooterTextBarDemo
//
//  Created by XuYafei on 16/2/17.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat refrenceLeft = 5;
static CGFloat refrenceTop = 7;
static CGFloat refrenceHeight = 2.693359375;
static CGFloat refrenceIncrease = 1.193359375;

@interface LPTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) NSUInteger textLimit;

@end
