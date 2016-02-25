//
//  LPFooterTextView.h
//  LPFooterTextBarDemo
//
//  Created by XuYafei on 16/2/17.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPTextView.h"

@class LPFooterTextView;

@protocol LPFooterTextViewDelegate <NSObject>

@optional

- (void)textView:(LPFooterTextView *)textView heightDidChangeBy:(CGFloat)height
    withDuration:(CGFloat)duration;
- (void)textView:(LPFooterTextView *)textView textDidChangeTo:(NSString *)text;
- (void)textView:(LPFooterTextView *)textView didCommitWithText:(NSString *)text;

@end

typedef NS_ENUM(NSInteger, LPGrowingMode) {
    LPGrowingModeTop,
    LPGrowingModeBottom,
    LPGrowingModeCenter,
};

typedef void(^CommitHandle)(NSString *text);

@interface LPFooterTextView : LPTextView

@property (nonatomic, assign) BOOL notMoveY;
@property (nonatomic, assign) CGFloat heightLimit;
@property (nonatomic, assign) LPGrowingMode growingMode;

@property (nonatomic, weak) id<LPFooterTextViewDelegate> footerDelegate;

@property (nonatomic, assign) BOOL returnToCommit;
@property (nonatomic, assign) BOOL autoClear;
@property (nonatomic, copy) CommitHandle commitHandle;

- (void)returnToCommitWithAutoClear:(BOOL)autoClear
                       CommitHandle:(CommitHandle)commitHandle;

@end
