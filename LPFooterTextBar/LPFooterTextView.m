//
//  LPFooterTextView.m
//  LPFooterTextBarDemo
//
//  Created by XuYafei on 16/2/17.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPFooterTextView.h"

static CGFloat duration = 0.25;

@interface LPFooterTextView () <UITextViewDelegate>

@end

@implementation LPFooterTextView {
    CGFloat _defaultViewHeight;
    BOOL _needLayout;
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
                textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        _heightLimit = 100;
        _autoClear = YES;
        _returnToCommit = YES;
        _growingMode = LPGrowingModeBottom;
        _defaultViewHeight = CGRectGetHeight(self.frame);
        self.bounces = NO;
        self.delegate = self;
        self.textLimit = 140;
        self.returnKeyType = UIReturnKeySend;
        self.enablesReturnKeyAutomatically = YES;
        self.layoutManager.allowsNonContiguousLayout = NO;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return self;
}

#pragma mark - Accessor

- (void)setFrame:(CGRect)frame {
    if (CGRectEqualToRect(self.frame, CGRectZero)
        && !CGRectEqualToRect(frame, CGRectZero)) {
        _defaultViewHeight = CGRectGetHeight(frame);
    }
    [super setFrame:frame];
    [self __setNeedsLayout];
    [self performSelector:@selector(frameTest) withObject:nil afterDelay:0];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (_footerDelegate && [_footerDelegate respondsToSelector:@selector(textView:textDidChangeTo:)]) {
        [_footerDelegate textView:self textDidChangeTo:text];
    }
    [self __setNeedsLayout];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self __setNeedsLayout];
}

- (void)setReturnToCommit:(BOOL)returnToCommit {
    _returnToCommit = returnToCommit;
    self.returnKeyType = UIReturnKeyDefault;
}

#pragma mark - Commit

- (void)returnToCommitWithAutoClear:(BOOL)autoClear
                       CommitHandle:(CommitHandle)commitHandle {
    _returnToCommit = YES;
    _autoClear = autoClear;
    _commitHandle = commitHandle;
}

#pragma mark - Layout

- (void)__setNeedsLayout {
    if (!_needLayout) {
        _needLayout = YES;
        [self performSelector:@selector(__layoutTextView) withObject:nil afterDelay:0];
    }
}

- (void)__layoutTextView {
    _needLayout = YES;
    CGFloat textHeightOffset;
    if (self.contentSize.height < _defaultViewHeight) {
        textHeightOffset = _defaultViewHeight - CGRectGetHeight(self.frame);
    } else if (self.contentSize.height > _heightLimit) {
        textHeightOffset = _heightLimit - CGRectGetHeight(self.frame);
    } else {
        textHeightOffset = self.contentSize.height - CGRectGetHeight(self.frame);
    }
    
    if (self.contentSize.height != CGRectGetHeight(self.frame)
        && self.contentSize.height > 0) {
        CGRect frame = self.frame;
        frame.size.height += textHeightOffset;
        if (_growingMode == LPGrowingModeTop) {
            frame.origin.y -= _notMoveY? 0: textHeightOffset;
        } else if (_growingMode == LPGrowingModeCenter) {
            frame.origin.y -= _notMoveY? 0: textHeightOffset / 2;
        }
        
        if (CGRectEqualToRect(frame, self.frame)) {
            _needLayout = NO;
            return;
        }
        [UIView animateWithDuration:duration animations:^{
            self.frame = frame;
        }];
        if (_footerDelegate && [_footerDelegate respondsToSelector:@selector(textView:heightDidChangeBy:withDuration:)]) {
            [_footerDelegate textView:self
                    heightDidChangeBy:textHeightOffset
                         withDuration:duration];
        }
    }
    _needLayout = NO;
}

- (void)frameTest {
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        return;
    }
    if (CGRectGetHeight(self.frame) >= _heightLimit) {
        return;
    }
    if (!CGRectGetHeight(self.frame)) {
        NSLog(@"Warning: You had do something wrong to cause the %@ height "
              "change to 0.000000",
              NSStringFromClass([self class]));
        return;
    }
    if (CGRectGetHeight(self.frame) < self.contentSize.height) {
        NSLog(@"Warning: You had better to change the %@ height from %f to %f "
              "or the %@ height will auto changed when you input the first word"
              " and the %@ will auto scroll when it become the first responder",
              NSStringFromClass([self class]),
              CGRectGetHeight(self.frame),
              self.contentSize.height,
              NSStringFromClass([self class]),
              NSStringFromClass([self class]));
    };
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if (_returnToCommit && [text isEqualToString:@"\n"]) {
        _commitHandle? _commitHandle(self.text): nil;
        _autoClear? self.text = [NSString string]: nil;
        [self resignFirstResponder];
        if (_footerDelegate && [_footerDelegate respondsToSelector:@selector(textView:didCommitWithText:)]) {
            [_footerDelegate textView:self didCommitWithText:textView.text];
        }
        return NO;
    } else {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (_footerDelegate && [_footerDelegate respondsToSelector:@selector(textView:textDidChangeTo:)]) {
        [_footerDelegate textView:self textDidChangeTo:textView.text];
    }
    [self __layoutTextView];
}

@end
