//
//  MGLBarChartView.h
//  MGLDevelopmentKit
//
//  Created by kaxiaoer on 15/1/4.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class MGLBarChartView;

@protocol MGLBarChartViewDataSource

@required
- (NSUInteger)numberOfRows;
- (NSNumber *)valueOfIndex:(NSInteger)index;
- (UIView *)viewOfIndex:(NSInteger)index;
@optional
- (UIColor *)colorOfIndex:(NSInteger)index;
- (CGFloat)xCenterValueOfIndex:(NSInteger)index;
- (CGSize)sizeOfIndex:(NSInteger)index;
@end

@interface MGLBarChartView : UIView

@property (copy, nonatomic) NSString *leftTitle,*rightTitle;
@property (strong, nonatomic) UIColor *leftThemeColor,*rightThemeColor;

@property (assign, nonatomic) double maxValue;
@property (strong, nonatomic) NSArray *leftDatas;
@property (strong, nonatomic) NSArray *rightDatas;

@property (weak,nonatomic) id<MGLBarChartViewDataSource> delegate;

- (void)setup;//刷新view
- (void)reloadData;

@end

@protocol MGLBarChartDelegate <NSObject>

@end