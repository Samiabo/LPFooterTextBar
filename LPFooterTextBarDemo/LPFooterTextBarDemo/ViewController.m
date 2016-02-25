//
//  ViewController.m
//  LPFooterTextBarDemo
//
//  Created by XuYafei on 16/2/17.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "ViewController.h"
#import "LPFooterTextBar.h"
#import <Masonry.h>

@implementation ViewController {
    LPFooterTextBar *_footerTextBar;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"LPFooterTextBar";
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBegan)]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 67,
                              CGRectGetWidth(self.view.bounds), 67);
    _footerTextBar = [[LPFooterTextBar alloc] initWithFrame:frame];
    _footerTextBar.textView.font = [UIFont systemFontOfSize:17];
    _footerTextBar.textView.placeholder = @"请输入文字";
    
    UIButton *button = [UIButton new];
    button.backgroundColor = self.view.tintColor;
    [button setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    _footerTextBar.commitButtonItem = [[LPFooterTextItem alloc] initWithButton:button];
    [self.view addSubview:_footerTextBar];
    
//    [_footerTextBar mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(self.view);
//        make.height.mas_equalTo(67);
//        make.bottom.equalTo(self.view);
//    }];
}

- (void)touchesBegan {
    [_footerTextBar resignFirstResponder];
}

@end
