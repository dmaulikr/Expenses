//
//  CompletionCircleView.m
//  Expenses
//
//  Created by Hendrik Noeller on 02.07.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "CompletionCircleView.h"
@interface CompletionCircleView ()
@property (strong, nonatomic) CAShapeLayer *backCircleLayer;
@property (strong, nonatomic) CAShapeLayer *completingCircleLayer;
@end

@implementation CompletionCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
  
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.frame = self.frame;
    if (!_backCircleLayer) {
        _backCircleLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_backCircleLayer];
        
        _backCircleLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
        _backCircleLayer.lineWidth = self.frame.size.width / 27;
        _backCircleLayer.fillColor = [UIColor colorWithWhite:0.0 alpha:0.0].CGColor;
//        _backCircleLayer.fillRule = @"Gradient from light green to original green, top to bottom";
    }
    if (!_completingCircleLayer) {
        _completingCircleLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_completingCircleLayer];
        
        _completingCircleLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
        _completingCircleLayer.lineWidth = 10;
        _completingCircleLayer.fillColor = [UIColor colorWithWhite:0.0 alpha:0.0].CGColor;
//        _backCircleLayer.fillRule = @"Gradient from slightly desatured, orangish red to 255 red, top to bottom";
        
        _completingCircleLayer.transform = CATransform3DRotate(_completingCircleLayer.transform, -3.141528/2.0, 0.0, 0.0, 1.0);
        _completingCircleLayer.transform = CATransform3DTranslate(_completingCircleLayer.transform, -self.frame.size.width, 0.0, 0.0);
    }
    [self updateCompletion];
}

- (void)updateCompletion
{
    if (!_dataExisting) {
        _backCircleLayer.strokeColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        _completingCircleLayer.strokeEnd = 0.0;
    } else {
        _completingCircleLayer.strokeColor = [UIColor redColor].CGColor;
        _backCircleLayer.strokeColor = [UIColor colorWithRed:0.0 green:0.721 blue:0.5215 alpha:1.0].CGColor;
        _completingCircleLayer.strokeStart = 0;
        _completingCircleLayer.strokeEnd = _completion;
    }
}

- (void)setCompletion:(double)completion
{
    _completion = completion;
    _completingCircleLayer.strokeEnd = _completion;
}

- (void)setDataExisting:(BOOL)dataExisting
{
    _dataExisting = dataExisting;
    [self updateCompletion];
}

@end
