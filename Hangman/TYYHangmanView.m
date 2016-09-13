//
//  TYYHangmanView.m
//  Hangman
//
//  Created by lele on 16/9/11.
//  Copyright © 2016年 tianyu. All rights reserved.
//

#import "TYYHangmanView.h"

@interface TYYHangmanView ()

@property (assign, nonatomic) int stepCount;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *letterLabelArray;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *underLineArray;
@property (strong, nonatomic) UIView *manView;
@property (strong, nonatomic) UIBezierPath *framePath;
@property (strong, nonatomic) UIBezierPath *manPath;
@property (assign, nonatomic) CGFloat viewWidth;
@property (assign, nonatomic) CGFloat viewHeight;

@end

@implementation TYYHangmanView

- (void)setupHangmanView {
    _viewWidth = self.frame.size.width;
    _viewHeight = self.frame.size.height;
    
    _framePath = [[UIBezierPath alloc] init];
    _framePath.lineWidth = 4;
    
    _manPath = [[UIBezierPath alloc] init];
    _manPath.lineWidth = 2;
}

- (void)startGameWithLetterCount:(NSInteger)count {
    for (int index = 0; index < count; index++) {
        UILabel *label = _letterLabelArray[index];
        label.hidden = NO;
        UIView *line = _underLineArray[index];
        line.hidden = NO;
    }
    _stepCount = 0;
    
    if (_manView) {
        [_manView removeFromSuperview];
        _manView = nil;
        _framePath = nil;
        _manView = nil;
        _framePath = [[UIBezierPath alloc] init];
        _framePath.lineWidth = 4;
        
        _manPath = [[UIBezierPath alloc] init];
        _manPath.lineWidth = 2;
    }
    _manView = [[UIView alloc] initWithFrame:self.bounds];
    [self insertSubview:_manView atIndex:0];
}

- (void)showWordsWithString:(NSString *)str {
    int strLength = (int)str.length;
    for (int index = 0; index < strLength; index++) {
        NSString *substr = [str substringWithRange:NSMakeRange(index, 1)];
        if ([substr isEqualToString:@"*"]) {
            //this substring is *
            continue;
        } else {
            UILabel *label = _letterLabelArray[index];
            label.text = substr;
        }
    }
}

- (void)drawNextStep {
    switch (_stepCount) {
        case 0:
            [_framePath moveToPoint:CGPointMake(0, _viewHeight - 4)];
            [_framePath addLineToPoint:CGPointMake(_viewWidth, _viewHeight - 4)];
            _stepCount += 1;
            [self addShapeLayerWithPath:_framePath];
            break;
        case 1:
            [_framePath moveToPoint:CGPointMake(25, _viewHeight - 4)];
            [_framePath addLineToPoint:CGPointMake(25, 25)];
            _stepCount += 1;
            [self addShapeLayerWithPath:_framePath];
            break;
        case 2:
            [_framePath moveToPoint:CGPointMake(25, 25)];
            [_framePath addLineToPoint:CGPointMake(_viewWidth - 50, 25)];
            _stepCount += 1;
            [self addShapeLayerWithPath:_framePath];
            break;
        case 3:
            [_framePath moveToPoint:CGPointMake(_viewWidth - 75, 25)];
            [_framePath addLineToPoint:CGPointMake(_viewWidth - 75, 55)];
            _stepCount += 1;
            [self addShapeLayerWithPath:_framePath];
            break;
        case 4:
            [_manPath moveToPoint:CGPointMake(_viewWidth - 50, 80)];
            [_manPath addArcWithCenter:CGPointMake(_viewWidth - 75, 80) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
            _stepCount += 1;
            [self addShapeLayerWithPath:_manPath];
            break;
        case 5:
            [_manPath moveToPoint:CGPointMake(_viewWidth - 75, 105)];
            [_manPath addLineToPoint:CGPointMake(_viewWidth - 75, 140)];
            _stepCount += 1;
            [self addShapeLayerWithPath:_manPath];
            break;
        case 6:
            [_manPath moveToPoint:CGPointMake(_viewWidth - 75, 120)];
            [_manPath addLineToPoint:CGPointMake(_viewWidth - 95, 140)];
            _stepCount += 1;
            [self addShapeLayerWithPath:_manPath];
            break;
        case 7:
            [_manPath moveToPoint:CGPointMake(_viewWidth - 75, 120)];
            [_manPath addLineToPoint:CGPointMake(_viewWidth - 55, 140)];
            _stepCount += 1;
            [self addShapeLayerWithPath:_manPath];
            break;
        case 8:
            [_manPath moveToPoint:CGPointMake(_viewWidth - 75, 140)];
            [_manPath addLineToPoint:CGPointMake(_viewWidth - 95, 175)];
            _stepCount += 1;
            [self addShapeLayerWithPath:_manPath];
            break;
        case 9:
            [_manPath moveToPoint:CGPointMake(_viewWidth - 75, 140)];
            [_manPath addLineToPoint:CGPointMake(_viewWidth - 55, 175)];
            _stepCount = 0;
            [self addShapeLayerWithPath:_manPath];
            break;
        default:
            break;
    }
}

- (void)clearTheHangman {
    for (int index = 0; index < _letterLabelArray.count; index++) {
        UILabel *label = _letterLabelArray[index];
        label.text = @"";
        label.hidden = YES;
        UIView *line = _underLineArray[index];
        line.hidden = YES;
    }
}

- (void)addShapeLayerWithPath:(UIBezierPath *)path {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = path.lineWidth;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    [self.manView.layer addSublayer:shapeLayer];
}

@end
