//
//  SYCycleImageView.m
//  SYScrollerViewCycleDemo
//
//  Created by 孙宇 on 2017/1/6.
//  Copyright © 2017年 孙宇. All rights reserved.
//

#import "SYCycleImageView.h"
#import "UIImageView+WebCache.h"

@interface SYCycleImageView ()

@property (nonatomic, assign) SYImageViewState state;
@property (nonatomic, assign) CGFloat cycleWidth;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SYCycleImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapClick)];
        [self addGestureRecognizer:tap];
        
        [self customUI];
    }
    return self;
}

#pragma mark - UI
- (void)customUI
{
    [self addSubview:self.maskView];
    [self.maskView addSubview:self.textLabel];
    [self layoutWithUI];
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = [UIColor colorWithRed:20.f/255.f green:20.f/255.f blue:20.f/255.f alpha:0.4];
        _maskView.hidden = YES;
        _maskView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _maskView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return _textLabel;
}

- (void)layoutWithUI
{
    // maskView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.cycleWidth]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.f]];
    
    // textLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.maskView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:12.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.maskView attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.f]];
}




- (void)layoutSubviews
{
    if (self.cycleWidth == 0) {
        return;
    }
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self convertRect:self.bounds toView:window];
    
    if (rect.origin.x <= -self.cycleWidth ||
        rect.origin.x >= self.cycleWidth) {
        
        if (self.callback) {
            self.state = SYImageViewStateOut;
            self.callback(SYImageViewStateOut, self);
        }
    }else{
        if (self.callback && self.state != SYImageViewStateShow) {
            self.state = SYImageViewStateShow;
            self.callback(SYImageViewStateShow, self);
        }
    }
    
    if (self.model.text == nil) {
        self.maskView.hidden = YES;
    }else{
        self.maskView.hidden = NO;
        self.textLabel.text = self.model.text;
    }
    
}

- (CGFloat)cycleWidth
{
    return self.bounds.size.width;
}


- (void)setModel:(SYCycleModel *)model
{
    _model = model;
    [self addImage];
}

- (void)addImage
{
    if ([self.model.img hasPrefix:@"http://"] ||
        [self.model.img hasPrefix:@"https://"]) {
        
        [self sd_setImageWithURL:[NSURL URLWithString:self.model.img]];
        
    }else{
        [self setImage:[UIImage imageNamed:self.model.img]];
    }
}

- (void)onTapClick
{    
    if (self.touchCallback) {
        self.touchCallback(self);
    }
}


@end
