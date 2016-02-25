//
//  LPFooterTextBar.h
//  LPFooterTextBarDemo
//
//  Created by XuYafei on 16/2/17.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPFooterTextView.h"
#import "LPFooterTextItem.h"

@class LPFooterTextBar;

@protocol LPFooterTextBarDelegate <NSObject>

@optional

- (void)textBar:(LPFooterTextBar *)textBar heightDidChangeBy:(CGFloat)height
    withDuration:(CGFloat)duration;
- (void)textBar:(LPFooterTextBar *)textBar textDidChangeTo:(NSString *)text;
- (void)textBar:(LPFooterTextBar *)textBar didCommitWithText:(NSString *)text;

@end

typedef NS_ENUM(NSInteger, LPBounceMode) {
    LPBounceModeNone,
    LPBounceModeTextBar,
    LPBounceModeSuperView,
};

@interface LPFooterTextBar : UIView

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) UIEdgeInsets textViewEdgeInsets;

@property (nonatomic, strong) LPFooterTextView *textView;
@property (nonatomic, strong) LPFooterTextItem *commitButtonItem;
@property (nonatomic, strong) NSArray<LPFooterTextItem *> *leftBarButtonItems;
@property (nonatomic, strong) NSArray<LPFooterTextItem *> *rightBarButtonItems;

@property (nonatomic, assign) LPBounceMode bounceMode;

- (BOOL)resignFirstResponder;

@end
