//
//  JPSegmentControl.h
//  teacher
//
//  Created by 朱佳鹏 on 15/8/17.
//  Copyright (c) 2015年 ws. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JPSegmentControlStyle) {
    JPSegmentControlStyleLine,//默认从0开始，线条样式
    JPSegmentControlStyleFill,//填充样式
};

typedef NS_ENUM(NSInteger, JPSegmentControlAnimation) {
    JPSegmentControlAnimationNone,
    JPSegmentControlAnimationSlide,
    JPSegmentControlAnimationSlideWidth,
};

@interface JPSegmentControl : UIControl {
    
}

@property (nonatomic, assign) JPSegmentControlStyle segmentedControlStyle;
@property (nonatomic, assign) JPSegmentControlAnimation segmentedControlAnimation;
@property (nonatomic,readonly) NSUInteger numberOfSegments;
@property (nonatomic, assign) NSUInteger selectIndex;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *selectColor;

- (void)insertSegmentWithTitles:(NSArray *)titles;
- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated;
- (void)insertSegmentWithImage:(UIImage *)image  atIndex:(NSUInteger)segment animated:(BOOL)animated;
- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated;
- (void)removeAllSegments;

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;
- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment;

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment;
- (UIImage *)imageForSegmentAtIndex:(NSUInteger)segment;

- (void)setWidth:(CGFloat)width forSegmentAtIndex:(NSUInteger)segment;
- (CGFloat)widthForSegmentAtIndex:(NSUInteger)segment;

@end
