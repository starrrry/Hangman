//
//  TYYKeyboardView.m
//  Hangman
//
//  Created by lele on 16/9/13.
//  Copyright © 2016年 tianyu. All rights reserved.
//

#import "TYYKeyboardView.h"

@interface TYYKeyboardView()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keyArray;
@property (strong, nonatomic) UIView *view;

@end

@implementation TYYKeyboardView

- (void)initFromXib {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"TYYKeyboardView" owner:self options:nil] firstObject];
    view.frame = self.bounds;
    [self addSubview:view];
    self.view = view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initFromXib];
        for (int index = 0; index < 26; index++) {
            UIButton *button = [_keyArray objectAtIndex:index];
            [button addTarget:self action:@selector(tapKey:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

- (void)keyWordIsRight:(NSString *)key {
    int index = [key characterAtIndex:0] - 65;
    UIButton *button = [_keyArray objectAtIndex:index];
    [button.titleLabel setTextColor:[UIColor greenColor]];
    button.userInteractionEnabled = NO;
}

- (void)keyWordIsWrong:(NSString *)key {
    int index = [key characterAtIndex:0] - 65;
    UIButton *button = [_keyArray objectAtIndex:index];
    [button.titleLabel setTextColor:[UIColor redColor]];
    button.userInteractionEnabled = NO;
}

- (void)restartGame {
    for (int index = 0; index < 26; index++) {
        UIButton *button = [_keyArray objectAtIndex:index];
        [button.titleLabel setTextColor:[UIColor blackColor]];
        button.userInteractionEnabled = YES;
    }
    self.hidden = YES;
}

- (void)tapKey:(UIButton *)sender {
    [self.delegate keyBoardGetKey:sender.titleLabel.text];
}


@end
