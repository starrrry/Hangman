//
//  ViewController.m
//  Hangman
//
//  Created by lele on 16/9/11.
//  Copyright © 2016年 tianyu. All rights reserved.
//

#import "ViewController.h"
#import "TYYHangmanRequest.h"
#import "TYYKeyboardView.h"
#import "TYYHangmanView.h"
#import "SVProgressHUD.h"
#import "SCLAlertView.h"

@interface ViewController () <TYYRequestDelegate, TYYKeyboardDelegate>

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starImageViewArray;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordsNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *livesLabel;
@property (strong, nonatomic) IBOutlet TYYHangmanView *hangmanView;
@property (strong, nonatomic) IBOutlet UIImageView *readyImageView;
@property (strong, nonatomic) TYYHangmanRequest *requestManager;
@property (strong, nonatomic) TYYKeyboardView *keyboard;
@property (copy, nonatomic) NSString *sessionId;
@property (copy, nonatomic) NSString *currentGuessKey;
@property (assign, nonatomic) NSInteger wordNumber;
@property (assign, nonatomic) NSInteger currentWordsCount;
@property (assign, nonatomic) NSInteger currentWrongCount;
@property (assign, nonatomic) NSInteger livesNumber;
@property (assign, nonatomic) BOOL gameIsOver;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _requestManager = [[TYYHangmanRequest alloc] init];
    _requestManager.delegate = self;
    
    _keyboard = [[TYYKeyboardView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 205, self.view.frame.size.width, 205)];
    _keyboard.delegate = self;
    [self.view addSubview:_keyboard];
    _keyboard.hidden = YES;
    
    _startButton.layer.cornerRadius = 35;
    _startButton.layer.masksToBounds = YES;
}

- (IBAction)tapStartButton:(UIButton *)sender {
    [SVProgressHUD show];
    [_requestManager startGameRequest];
    _currentWordsCount = 0;
    _currentWrongCount = 0;
    _gameIsOver = NO;
    _keyboard.userInteractionEnabled = YES;
    [_hangmanView setupHangmanView];
    _readyImageView.hidden = YES;
}

- (void)lightStarWithCount:(int)count {
    if (count == 0) {
        for (int index = 0; index < 4; index++) {
            UIImageView *imageView = _starImageViewArray[index];
            imageView.image = [UIImage imageNamed:@"star"];
        }
        return;
    }
    for (int index = 0; index < count; index++) {
        UIImageView *imageView = _starImageViewArray[index];
        imageView.image = [UIImage imageNamed:@"light-star"];
    }
}

#pragma mark TYYRequestDelegate

- (void)startGameGetNumberOfWordsToGuess:(NSInteger)wordNumber numberOfGuessAllowedForEachWord:(NSInteger)livesNumber sessionId:(NSString *)sessionId {
    _scoreLabel.text = @"0";
    _wordsNumberLabel.text = @"0";
    _livesNumber = livesNumber;
    _sessionId = sessionId;
    _wordNumber = wordNumber;
    _startButton.hidden = YES;
    [_requestManager giveMeAWordRequestWithSessionId:_sessionId];
}

- (void)giveMeAWord:(NSString *)word totalWordCount:(NSInteger)totalCount wrongGuessCountOfCurrentWord:(NSInteger)wrongCount {
    _currentWordsCount += 1;
    [SVProgressHUD dismiss];
    NSInteger wordLengh = word.length;
    if (wordLengh <= 5) {
        [self lightStarWithCount:1];
    } else if (wordLengh <= 8) {
        [self lightStarWithCount:2];
    } else if (wordLengh <= 12) {
        [self lightStarWithCount:3];
    } else {
        [self lightStarWithCount:4];
    }
    _keyboard.hidden = NO;
    _keyboard.userInteractionEnabled = YES;
    _livesLabel.text = [NSString stringWithFormat:@"%zd",_livesNumber];
    [_hangmanView startGameWithLetterCount:wordLengh];
}

- (void)makeAGuessGetWord:(NSString *)word totalWordCount:(NSInteger)totalCount wrongGuessCountOfCurrentWord:(NSInteger)wrongCount {
    if (wrongCount == 10) {
        //game over
        _startButton.hidden = NO;
        _gameIsOver = YES;
        [_keyboard restartGame];
        [_hangmanView clearTheHangman];
        [_hangmanView drawNextStep];
        [SVProgressHUD show];
        [_requestManager getYourResultRequestWithSessionId:_sessionId];
        [self lightStarWithCount:0];
        _livesLabel.text = @"";
        _scoreLabel.text = @"";
        _wordsNumberLabel.text = @"";
        return;
    }
    if (![word containsString:@"*"]) {
        //the word is right
        if (_currentWordsCount <= _wordNumber) {
            [SVProgressHUD showWithStatus:@"next word,wait!"];
            _currentWrongCount = 0;
            [_requestManager getYourResultRequestWithSessionId:_sessionId];
            [_requestManager giveMeAWordRequestWithSessionId:_sessionId];
            [_hangmanView clearTheHangman];
            [_keyboard restartGame];
        } else {
            //guess all words
            [SVProgressHUD show];
            [_requestManager submitYourResultRequestWithSessionId:_sessionId];
        }
        return;
    }
    if (_currentWrongCount == wrongCount) {
        //this word is right
        [_keyboard keyWordIsRight:_currentGuessKey];
        [_hangmanView showWordsWithString:word];
    } else {
        //this word is wrong
        _currentWrongCount = wrongCount;
        NSInteger lives = 10 - wrongCount;
        _livesLabel.text = [NSString stringWithFormat:@"%zd",lives];
        [_hangmanView drawNextStep];
        [_keyboard keyWordIsWrong:_currentGuessKey];
    }
    _keyboard.userInteractionEnabled = YES;
}

- (void)getResultTotalWordCount:(NSInteger)totalCount correctWordCount:(NSInteger)correctCount totalWrongGuessCount:(NSInteger)totalWrongCount score:(NSInteger)score {
    if (_gameIsOver) {
        [SVProgressHUD dismiss];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showInfo:self title:@"GAME OVER"
               subTitle:[NSString stringWithFormat:@"You tried words:%zd\nYou guess correnctly:%zd\nYour wrong guess:%zd\nYour score:%zd",totalCount,correctCount,totalWrongCount,score]
       closeButtonTitle:@"OK"
               duration:0.0f];
    } else {
        _wordsNumberLabel.text = [NSString stringWithFormat:@"%zd",correctCount];
        _scoreLabel.text = [NSString stringWithFormat:@"%zd",score];
    }
}

- (void)submitYourResultPlayerId:(NSString *)playerId totalWordCount:(NSInteger)totalCount correctWordCount:(NSInteger)correctCount totalWrongGuessCount:(NSInteger)totalWrongCount score:(NSInteger)score datetime:(NSString *)datetime {
    [SVProgressHUD dismiss];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showInfo:self title:@"Congratulations!"
           subTitle:[NSString stringWithFormat:@"You tried words:%zd\nYou guess correnctly:%zd\nYour wrong guess:%zd\nYour score:%zd",totalCount,correctCount,totalWrongCount,score]
   closeButtonTitle:@"OK"
           duration:0.0f];
    _startButton.hidden = NO;
    _gameIsOver = YES;
    [_keyboard restartGame];
    [_hangmanView clearTheHangman];
    [self lightStarWithCount:0];
    _livesLabel.text = @"";
    _scoreLabel.text = @"";
    _wordsNumberLabel.text = @"";
}

#pragma mark TYYKeyboardDelegate

- (void)keyBoardGetKey:(NSString *)key {
    [_requestManager makeAGuessRequestWithSessionId:_sessionId guess:key];
    _keyboard.userInteractionEnabled = NO;
    _currentGuessKey = key;
}

@end
