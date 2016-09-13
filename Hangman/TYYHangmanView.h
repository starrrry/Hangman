//
//  TYYHangmanView.h
//  Hangman
//
//  Created by lele on 16/9/11.
//  Copyright © 2016年 tianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYYHangmanView : UIView

- (void)setupHangmanView;

//after start the game , draw letter lines.
- (void)startGameWithLetterCount:(NSInteger)count;

- (void)showWordsWithString:(NSString *)str;

//when guess is wrong , draw next step.
- (void)drawNextStep;

//when the word is done , clear the hangman.
- (void)clearTheHangman;

@end
