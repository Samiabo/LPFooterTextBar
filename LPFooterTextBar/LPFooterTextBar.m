//
//  LPFooterTextBar.m
//  LPFooterTextBarDemo
//
//  Created by XuYafei on 16/2/17.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPFooterTextBar.h"

@interface LPFooterTextBar () <LPFooterTextViewDelegate>

@end

@implementation LPFooterTextBar {
    CGFloat _heightOffset;
    CGFloat _yOffset;
    BOOL _needLayout;
    UIColor *_commitButtonColor;
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bounceMode = LPBounceModeTextBar;
        _edgeInsets = UIEdgeInsetsMake(defaultEdgeInsets,
                                       defaultEdgeInsets / 2,
                                       defaultEdgeInsets,
                                       defaultEdgeInsets / 2);
        _textViewEdgeInsets = UIEdgeInsetsMake(0, defaultEdgeInsets / 2,
                                               0, defaultEdgeInsets / 2);
        _textView = [[LPFooterTextView alloc] initWithFrame:CGRectZero];
        _textView.growingMode = LPGrowingModeTop;
        _textView.footerDelegate = self;
        _textView.notMoveY = YES;
        _textView.layer.borderColor = _textView.placeholderColor.CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.cornerRadius = 5;
        [self addSubview:_textView];
        
        self.layer.borderColor = _textView.placeholderColor.CGColor;
        self.layer.borderWidth = 0.5;
        
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(keyboardWillChangeFrame:)
                           name:UIKeyboardWillChangeFrameNotification
                         object:nil];
        
        [self __setNeedsLayout];
    }
    return self;
}

- (void)dealloc {
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:UIKeyboardWillChangeFrameNotification
                        object:nil];
}

- (BOOL)resignFirstResponder {
    [_textView resignFirstResponder];
    return [super resignFirstResponder];
}

#pragma mark - Accessor

- (void)setLeftBarButtonItems:(NSArray<LPFooterTextItem *> *)leftBarButtonItems {
    if (_leftBarButtonItems) {
        for (LPFooterTextItem *item in _leftBarButtonItems) {
            UIButton *button = item.button;
            [button removeFromSuperview];
        }
    }
    _leftBarButtonItems = leftBarButtonItems;
    for (LPFooterTextItem *item in _leftBarButtonItems) {
        [self addSubview:item.button];
    }
    [self __setNeedsLayout];
}

- (void)setRightBarButtonItems:(NSArray<LPFooterTextItem *> *)rightBarButtonItems {
    if (_rightBarButtonItems) {
        for (LPFooterTextItem *item in _rightBarButtonItems) {
            UIButton *button = item.button;
            [button removeFromSuperview];
        }
    }
    _rightBarButtonItems = rightBarButtonItems;
    for (LPFooterTextItem *item in _rightBarButtonItems) {
        [self addSubview:item.button];
    }
    [self __setNeedsLayout];
}

- (void)setCommitButtonItem:(LPFooterTextItem *)commitButtonItem {
    if (_commitButtonItem) {
        [_commitButtonItem.button removeFromSuperview];
    }
    _commitButtonItem = commitButtonItem;
    _commitButtonItem.button.enabled = NO;
    _commitButtonItem.button.alpha = 0.4;
    _commitButtonColor = _commitButtonItem.button.backgroundColor;
    _commitButtonItem.button.backgroundColor = [UIColor blackColor];
    [_commitButtonItem.button addTarget:self action:@selector(textDidCommit:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commitButtonItem.button];
    [self __setNeedsLayout];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self __setNeedsLayout];
}

#pragma mark - Layout

- (void)__setNeedsLayout {
    if (!_needLayout) {
        _needLayout = YES;
        [self performSelector:@selector(__layoutSubviews)
                   withObject:nil
                   afterDelay:0];
    }
}

- (void)__layoutSubviews {
    _needLayout = YES;
    if (_yOffset) {
        if (_bounceMode == LPBounceModeTextBar) {
            CGRect frame = self.frame;
            frame.origin.y += _yOffset;
            self.frame = frame;
        } else if (_bounceMode == LPBounceModeSuperView) {
            CGRect frame = self.superview.frame;
            frame.origin.y += _yOffset;
            self.superview.frame = frame;
        }
        _yOffset = 0;
        _needLayout = NO;
        return;
    }
    
    if (_heightOffset) {
        CGRect frame = self.frame;
        if (_textView.growingMode == LPGrowingModeTop) {
            frame.origin.y -= _heightOffset;
            frame.size.height += _heightOffset;
        } else if (_textView.growingMode == LPGrowingModeBottom) {
            frame.size.height += _heightOffset;
        } else if (_textView.growingMode == LPGrowingModeCenter) {
            frame.origin.y -= _heightOffset / 2;
            frame.size.height += _heightOffset;
        }
        self.frame = frame;
        
        CGPoint center = CGPointZero;
        if (_leftBarButtonItems) {
            for (int i = 0; i < _leftBarButtonItems.count; i++) {
                center = _leftBarButtonItems[i].button.center;
                if (_textView.growingMode == LPGrowingModeTop) {
                    center.y += _heightOffset;
                } else if (_textView.growingMode == LPGrowingModeCenter) {
                    center.y += _heightOffset / 2;
                }
                _leftBarButtonItems[i].button.center = center;
            }
        }
        if (_rightBarButtonItems) {
            for (int i = 0; i < _leftBarButtonItems.count; i++) {
                center = _rightBarButtonItems[i].button.center;
                if (_textView.growingMode == LPGrowingModeTop) {
                    center.y += _heightOffset;
                } else if (_textView.growingMode == LPGrowingModeCenter) {
                    center.y += _heightOffset / 2;
                }
                _rightBarButtonItems[i].button.center = center;
            }
        }
        if (_commitButtonItem) {
            center = _commitButtonItem.button.center;
            if (_textView.growingMode == LPGrowingModeTop) {
                center.y += _heightOffset;
            } else if (_textView.growingMode == LPGrowingModeCenter) {
                center.y += _heightOffset / 2;
            }
            _commitButtonItem.button.center = center;
        }
        
        _heightOffset = 0;
        _needLayout = NO;
        return;
    }
    
    for (int i = 0; i < _leftBarButtonItems.count; i++) {
        UIButton *button = _leftBarButtonItems[i].button;
        UIEdgeInsets edgeInsets = _leftBarButtonItems[i].edgeInsets;
        CGFloat previousRight = _edgeInsets.left;
        if (i > 0) {
            previousRight = CGRectGetMaxX(_leftBarButtonItems[i-1].button.frame) + _leftBarButtonItems[i-1].edgeInsets.right;
        }
        button.frame = CGRectMake(previousRight + edgeInsets.left,
                                  _edgeInsets.top + edgeInsets.top,
                                  _leftBarButtonItems[i].width,
                                  self.frame.size.height
                                  - _edgeInsets.top
                                  - _edgeInsets.bottom
                                  - edgeInsets.top
                                  - edgeInsets.bottom);
    }
    
    CGRect textViewFrame = CGRectZero;
    textViewFrame.origin.x = CGRectGetMaxX(_leftBarButtonItems.lastObject.button.frame) + _leftBarButtonItems.lastObject.edgeInsets.right;
    if (!textViewFrame.origin.x) {
        textViewFrame.origin.x = _edgeInsets.left;
    }
    textViewFrame.origin.y = _edgeInsets.top + _textViewEdgeInsets.top;
    textViewFrame.size.height = CGRectGetHeight(self.frame)
    - CGRectGetMinY(textViewFrame)
    - _edgeInsets.bottom
    - _textViewEdgeInsets.bottom;
    
    if (_commitButtonItem) {
        UIButton *button = _commitButtonItem.button;
        button.frame = CGRectMake(CGRectGetWidth(self.frame)
                                  - _edgeInsets.right
                                  - _commitButtonItem.edgeInsets.right
                                  - _commitButtonItem.width,
                                  _edgeInsets.top + _commitButtonItem.edgeInsets.top,
                                  _commitButtonItem.width,
                                  CGRectGetHeight(self.frame)
                                  - _edgeInsets.top
                                  - _edgeInsets.bottom
                                  - _commitButtonItem.edgeInsets.top
                                  - _commitButtonItem.edgeInsets.bottom);
        
        textViewFrame.size.width = CGRectGetMinX(_commitButtonItem.button.frame)
        - CGRectGetMaxX(_leftBarButtonItems.lastObject.button.frame)
        - _leftBarButtonItems.lastObject.edgeInsets.right
        - _commitButtonItem.edgeInsets.left
        - _textViewEdgeInsets.left
        - _textViewEdgeInsets.right;
    } else {
        for (int i = (int)_rightBarButtonItems.count - 1; i >= 0; i--) {
            UIButton *button = _rightBarButtonItems[i].button;
            UIEdgeInsets edgeInsets = _rightBarButtonItems[i].edgeInsets;
            CGFloat nextLeft = CGRectGetWidth(self.frame);
            if (i < (int)_rightBarButtonItems.count - 1) {
                nextLeft = CGRectGetMinX(_rightBarButtonItems[i+1].button.frame) - _rightBarButtonItems[i+1].edgeInsets.left;
            }
            button.frame = CGRectMake(CGRectGetWidth(self.frame)
                                      - nextLeft
                                      - edgeInsets.right
                                      - _rightBarButtonItems[i].width,
                                      _edgeInsets.top + edgeInsets.top,
                                      _rightBarButtonItems[i].width,
                                      CGRectGetHeight(self.frame)
                                      - _edgeInsets.top
                                      - _edgeInsets.bottom
                                      - edgeInsets.top
                                      - edgeInsets.bottom);
        }
        
        textViewFrame.size.width = CGRectGetMinX(_rightBarButtonItems.firstObject.button.frame)
        - CGRectGetMaxX(_leftBarButtonItems.lastObject.button.frame)
        - _leftBarButtonItems.lastObject.edgeInsets.right
        - _rightBarButtonItems.firstObject.edgeInsets.left
        - _textViewEdgeInsets.left
        - _textViewEdgeInsets.right;
    }
    _textView.frame = textViewFrame;
    _needLayout = NO;
}

#pragma mark - LPFooterTextViewDelegate

- (void)textView:(LPFooterTextView *)textView
heightDidChangeBy:(CGFloat)height
    withDuration:(CGFloat)duration {
    _heightOffset = height;
    [UIView animateWithDuration:duration animations:^{
        [self __layoutSubviews];
    }];
    if (_delegate && [_delegate respondsToSelector:@selector(textBar:heightDidChangeBy:withDuration:)]) {
        [_delegate textBar:self heightDidChangeBy:height withDuration:duration];
    }
}

- (void)textView:(LPFooterTextView *)textView textDidChangeTo:(NSString *)text {
    if (text.length) {
        _commitButtonItem.button.enabled = YES;
        _commitButtonItem.button.alpha = 1.0;
        _commitButtonItem.button.backgroundColor = _commitButtonColor;
    } else {
        _commitButtonItem.button.enabled = NO;
        _commitButtonItem.button.alpha = 0.4;
        _commitButtonItem.button.backgroundColor = [UIColor blackColor];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(textBar:textDidChangeTo:)]) {
        [_delegate textBar:self textDidChangeTo:text];
    }
}

- (void)textView:(LPFooterTextView *)textView didCommitWithText:(NSString *)text {
    if (_delegate && [_delegate respondsToSelector:@selector(textBar:didCommitWithText:)]) {
        [_delegate textBar:self didCommitWithText:text];
    }
}

#pragma mark - Action

- (void)textDidCommit:(UIButton *)button {
    _textView.commitHandle? _textView.commitHandle(_textView.text): nil;
    _textView.autoClear? _textView.text = [NSString string]: nil;
    [_textView resignFirstResponder];
    if ([self respondsToSelector:@selector(textView:didCommitWithText:)]) {
        [self textView:_textView didCommitWithText:_textView.text];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    _yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    [UIView animateWithDuration:duration animations:^{
        [self __layoutSubviews];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textBar:keyboardWillChangeFrame:)]) {
        [_delegate textBar:self keyboardWillChangeFrame:info];
    }
}

@end
