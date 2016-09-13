//
//  TYYHangmanRequest.h
//  Hangman
//
//  Created by lele on 16/9/12.
//  Copyright © 2016年 tianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYYRequestDelegate;

@interface TYYHangmanRequest : NSObject

@property (weak, nonatomic) id<TYYRequestDelegate> delegate;

- (void)startGameRequest;

- (void)giveMeAWordRequestWithSessionId:(NSString *)sessionId;

- (void)makeAGuessRequestWithSessionId:(NSString *)sessionId guess:(NSString *)word;

- (void)getYourResultRequestWithSessionId:(NSString *)sessionId;

- (void)submitYourResultRequestWithSessionId:(NSString *)sessionId;

@end

@protocol TYYRequestDelegate <NSObject>

- (void)startGameGetNumberOfWordsToGuess:(NSInteger)wordNumber numberOfGuessAllowedForEachWord:(NSInteger)livesNumber sessionId:(NSString *)sessionId;

- (void)giveMeAWord:(NSString *)word totalWordCount:(NSInteger)totalCount wrongGuessCountOfCurrentWord:(NSInteger)wrongCount;

- (void)makeAGuessGetWord:(NSString *)word totalWordCount:(NSInteger)totalCount wrongGuessCountOfCurrentWord:(NSInteger)wrongCount;

- (void)getResultTotalWordCount:(NSInteger)totalCount correctWordCount:(NSInteger)correctCount totalWrongGuessCount:(NSInteger)totalWrongCount score:(NSInteger)score;

- (void)submitYourResultPlayerId:(NSString *)playerId totalWordCount:(NSInteger)totalCount correctWordCount:(NSInteger)correctCount totalWrongGuessCount:(NSInteger)totalWrongCount score:(NSInteger)score datetime:(NSString *)datetime;

@end