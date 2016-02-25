//
//  LPTextView.m
//  LPFooterTextBarDemo
//
//  Created by XuYafei on 16/2/17.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPTextView.h"

@implementation LPTextView {
    UILabel *_placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        _textLimit = 1000;
        _placeholder = [NSString string];
        _placeholderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.1 alpha:0.22];
        
        CGFloat placeholderHeight = refrenceHeight + (self.font.pointSize - 1) * refrenceIncrease;
        CGRect placeholderFrame = CGRectMake(refrenceLeft,
                                             refrenceTop,
                                             CGRectGetWidth(self.frame),
                                             placeholderHeight);
        _placeholderLabel = [[UILabel alloc] initWithFrame:placeholderFrame];
        _placeholderLabel.font = self.font;
        _placeholderLabel.textColor = _placeholderColor;
        [self addSubview:_placeholderLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChange:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 0.5;
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderLabel.text = _placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    _placeholderLabel.textColor = _placeholderColor;
}

- (void)setFont:(UIFont *)font {
    CGRect placeholderFrame = _placeholderLabel.frame;
    placeholderFrame.size.height = refrenceHeight + (font.pointSize - 1) * refrenceIncrease;
    _placeholderLabel.frame = placeholderFrame;
    _placeholderLabel.font = font;
    [super setFont:font];
}

- (void)setText:(NSString *)text {
    if (text.length) {
        _placeholderLabel.hidden = YES;
    } else {
        _placeholderLabel.hidden = NO;
    }
    [super setText:text];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect placeholderFrame = _placeholderLabel.frame;
    placeholderFrame.size.width = CGRectGetWidth(self.frame);
    _placeholderLabel.frame = placeholderFrame;
}

- (void)textDidChange:(NSNotification *)notification {
    NSString *text = [[notification object] text];
    if (text.length) {
        _placeholderLabel.hidden = YES;
        if (text.length > _textLimit) {
            self.text = [text substringToIndex:_textLimit];
        }
    } else {
        _placeholderLabel.hidden = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (BOOL)becomeFirstResponder {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
//                   dispatch_get_main_queue(), ^{
//        for (UIView *view in self.subviews) {
//            if ([view isKindOfClass:NSClassFromString(@"_UITextContainerView")]) {
//                for (UIView *subview in view.subviews) {
//                    if ([subview isKindOfClass:NSClassFromString(@"UITextSelectionView")]) {
//                        UIView *cursor = subview.subviews.firstObject;
//                        NSLog(@"%@", cursor);
//                        NSLog(@"%.100f", cursor.frame.size.height);
//                    }
//                }
//            }
//        }
//    });
//    return [super becomeFirstResponder];
//}

//size = 100  frame = (4 7; 2 120.8359375);
//size = 17   frame = (4 7; 2 21.787109375);
//size = 16   frame = (4 7; 2 20.59375);
//size = 15   frame = (4 7; 2 19.400390625);
//size = 10   frame = (4 7; 2 13.43359375);
//size = 8    frame = (4 7; 2 11.046875);
//size = 1    frame = (4 7; 2 2.693359375);

@end
