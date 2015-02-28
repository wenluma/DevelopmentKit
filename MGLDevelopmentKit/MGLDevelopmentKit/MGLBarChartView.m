//
//  MGLBarChartView.m
//  MGLDevelopmentKit
//
//  Created by kaxiaoer on 15/1/4.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import "MGLBarChartView.h"
#import "ToolHeader.h"
#import "UIView+Positioning.h"

const CGFloat leftPadding = 20, rightPadding = 20;

@interface MGLBarChartView ()
@property (assign, nonatomic) NSInteger rows;
@property (weak, nonatomic) UIView *contentView;
@property (weak, nonatomic) UILabel *leftTitleLab, *rightTitleLab;
@property (weak, nonatomic) UILabel *leftTimeLab, *rightTimeLab;
@property (strong, nonatomic) NSMutableArray *leftDatasViews;
@property (strong, nonatomic) NSMutableArray *rightDatasViews;
@property (assign, nonatomic) long long resultNumber;

@end

@implementation MGLBarChartView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        add contentView

        UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:contentView];
        contentView.backgroundColor = [UIColor clearColor];
        self.contentView = contentView;
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"轴"]];
        contentView.bounds = img.bounds;
        [_contentView addSubview:img];
        
        _contentView.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
        
        self.backgroundColor = [UIColor redColor];
        img.backgroundColor = [UIColor greenColor];
        
        _leftTitleLab = [self getLab];
        _rightTitleLab = [self getLab];
        _leftTimeLab = [self getLab];
        _rightTimeLab = [self getLab];
        
        NSMutableArray *leftDatasLayers = [[NSMutableArray alloc] initWithCapacity:1];
        _leftDatasViews = leftDatasLayers;
        NSMutableArray *rightDatasLayers = [[NSMutableArray alloc] initWithCapacity:1];
        _rightDatasViews = rightDatasLayers;
        
        _leftThemeColor = UIColorFromHex(0xff9f3b);
        _rightThemeColor = UIColorFromHex(0xb9c73a);
        
        [self addObserver:self forKeyPath:@"self.delegate" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(keyPath,nil);
    NSLog([change description],nil);
    id delegate = change[@"new"];
    NSAssert([delegate respondsToSelector:@selector(numberOfRows)], @"required methed");
    NSAssert([delegate respondsToSelector:@selector(valueOfIndex:)], @"required methed");
    NSAssert([delegate respondsToSelector:@selector(viewOfIndex:)], @"required methed");
    
    NSInteger count = [delegate numberOfRows];
    for (int i=0; i<count; i++) {
        
    }
    

}
- (UILabel *)getLab{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.backgroundColor = [UIColor clearColor];
    [self addSubview:lab];
    return lab;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
