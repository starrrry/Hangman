//
//  TYYKeyboardView.h
//  Hangman
//
//  Created by lele on 16/9/13.
//  Copyright © 2016年 tianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TYYKeyboardDelegate;


@interface TYYKeyboardView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)keyWordIsWrong:(NSString *)key;

- (void)keyWordIsRight:(NSString *)key;

- (void)restartGame;

@property (weak, nonatomic) id<TYYKeyboardDelegate> delegate;

@end

@protocol TYYKeyboardDelegate <NSObject>

- (void)keyBoardGetKey:(NSString *)key;

@end