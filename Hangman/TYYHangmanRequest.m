//
//  TYYHangmanRequest.m
//  Hangman
//
//  Created by lele on 16/9/12.
//  Copyright © 2016年 tianyu. All rights reserved.
//

#import "TYYHangmanRequest.h"
#import "AFNetworking/AFNetworking.h"

static NSString *requestUrl = @"https://strikingly-hangman.herokuapp.com";

@interface AFManager : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

@implementation AFManager

+ (instancetype)sharedClient {
    static AFManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFManager alloc] initWithBaseURL:[NSURL URLWithString:requestUrl]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer    serializer];
    });
    
    return _sharedClient;
}

@end


@implementation TYYHangmanRequest

- (void)startGameRequest {
    NSDictionary *parameters = @{@"playerId": @"im.tianyu.liao@gmail.com",
                                 @"action" : @"startGame"};
    
    [[AFManager sharedClient] POST:@"/game/on"
                        parameters:parameters
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               NSDictionary *respo = (NSDictionary *)responseObject;
                               [self.delegate startGameGetNumberOfWordsToGuess:[[[respo objectForKey:@"data"] objectForKey:@"numberOfWordsToGuess"] integerValue]
                                               numberOfGuessAllowedForEachWord:[[[respo objectForKey:@"data"] objectForKey:@"numberOfGuessAllowedForEachWord"] integerValue]
                                                                     sessionId:[respo objectForKey:@"sessionId"]];
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               NSLog(@"error:%@",error);
                               [self startGameRequest];
                           }];
}

- (void)giveMeAWordRequestWithSessionId:(NSString *)sessionId {
    NSDictionary *parameters = @{@"sessionId": sessionId,
                                 @"action" : @"nextWord"};
    
    [[AFManager sharedClient] POST:@"/game/on"
                        parameters:parameters
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               NSDictionary *respo = (NSDictionary *)responseObject;
                               [self.delegate giveMeAWord:[[respo objectForKey:@"data"] objectForKey:@"word"]
                                           totalWordCount:[[[respo objectForKey:@"data"] objectForKey:@"totalWordCount"] integerValue]
                             wrongGuessCountOfCurrentWord:[[[respo objectForKey:@"data"] objectForKey:@"wrongGuessCountOfCurrentWord"] integerValue]];
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               NSLog(@"error:%@",error);
                               [self giveMeAWordRequestWithSessionId:sessionId];
                           }];
}

- (void)makeAGuessRequestWithSessionId:(NSString *)sessionId guess:(NSString *)word {
    NSDictionary *parameters = @{@"sessionId": sessionId,
                                 @"action" : @"guessWord",
                                 @"guess" : word};
    
    [[AFManager sharedClient] POST:@"/game/on"
                        parameters:parameters
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               NSDictionary *respo = (NSDictionary *)responseObject;
                               [self.delegate makeAGuessGetWord:[[respo objectForKey:@"data"] objectForKey:@"word"]
                                                 totalWordCount:[[[respo objectForKey:@"data"] objectForKey:@"totalWordCount"] integerValue]
                                   wrongGuessCountOfCurrentWord:[[[respo objectForKey:@"data"] objectForKey:@"wrongGuessCountOfCurrentWord"] integerValue]];
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               NSLog(@"error:%@",error);
                               [self makeAGuessRequestWithSessionId:sessionId guess:word];
                           }];
}

- (void)getYourResultRequestWithSessionId:(NSString *)sessionId {
    NSDictionary *parameters = @{@"sessionId": sessionId,
                                 @"action" : @"getResult"};
    
    [[AFManager sharedClient] POST:@"/game/on"
                        parameters:parameters
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               NSDictionary *respo = (NSDictionary *)responseObject;
                               [self.delegate getResultTotalWordCount:[[[respo objectForKey:@"data"] objectForKey:@"totalWordCount"] integerValue]
                                                     correctWordCount:[[[respo objectForKey:@"data"] objectForKey:@"correctWordCount"] integerValue]
                                                 totalWrongGuessCount:[[[respo objectForKey:@"data"] objectForKey:@"totalWrongGuessCount"] integerValue]
                                                                score:[[[respo objectForKey:@"data"] objectForKey:@"score"] integerValue]];
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               NSLog(@"error:%@",error);
                               [self getYourResultRequestWithSessionId:sessionId];
                           }];
}

- (void)submitYourResultRequestWithSessionId:(NSString *)sessionId {
    NSDictionary *parameters = @{@"sessionId": sessionId,
                                 @"action" : @"submitResult"};
    
    [[AFManager sharedClient] POST:@"/game/on"
                        parameters:parameters
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               NSDictionary *respo = (NSDictionary *)responseObject;
                               [self.delegate submitYourResultPlayerId:[[respo objectForKey:@"data"] objectForKey:@"playerId"]
                                                        totalWordCount:[[[respo objectForKey:@"data"] objectForKey:@"totalWordCount"] integerValue]
                                                      correctWordCount:[[[respo objectForKey:@"data"] objectForKey:@"correctWordCount"] integerValue]
                                                  totalWrongGuessCount:[[[respo objectForKey:@"data"] objectForKey:@"totalWrongGuessCount"] integerValue]
                                                                 score:[[[respo objectForKey:@"data"] objectForKey:@"score"] integerValue]
                                                              datetime:[[respo objectForKey:@"data"] objectForKey:@"datetime"]];
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               NSLog(@"error:%@",error);
                               [self submitYourResultRequestWithSessionId:sessionId];
                           }];
}

@end
