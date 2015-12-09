//
//  JPSegmentControl.m
//  teacher
//
//  Created by 朱佳鹏 on 15/8/17.
//  Copyright (c) 2015年 ws. All rights reserved.
//

#import "JPSegmentControl.h"

#pragma mark 遮罩View
@interface JPSegmentControlMaskView : UIView {
    
}

@property(nonatomic, strong) UIView *colorView;

- (id)initWithFrame:(CGRect)frame andMaskImage:(UIImage *)maskImage titleCount:(NSUInteger)count;

@end

@implementation JPSegmentControlMaskView
@synthesize colorView;

- (id)initWithFrame:(CGRect)frame andMaskImage:(UIImage *)maskImage titleCount:(NSUInteger)count {
    self = [super initWithFrame:frame];
    if (self) {
        colorView = [[UIView alloc] init];
        colorView.frame = CGRectMake(0, 0, frame.size.width / count, frame.size.height);
        colorView.backgroundColor = [UIColor orangeColor];//默认颜色，可修改
        colorView.userInteractionEnabled = YES;
        [self addSubview:colorView];
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        maskLayer.contents = (__bridge id)maskImage.CGImage;
        self.layer.mask = maskLayer;
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end

#pragma mark 分段开关

@interface JPSegmentControl () {
    NSMutableArray *dataSource;
    UIView *selectBackView;
    UIImage *maskImage;
    UIView *titlesView;
    JPSegmentControlMaskView *jpMaskView;
    CGPoint startPoint;
    CGPoint lastMovedPoint;
    CGPoint startSelectViewCenter;
}

@end

@implementation JPSegmentControl
@synthesize selectIndex;

#pragma mark 事件处理

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint locInSelf = [touch locationInView:self];
    startPoint = locInSelf;
    startSelectViewCenter = selectBackView.center;
    [self findSelectIndexWithPoint:locInSelf];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint locInSelf = [touch locationInView:self];
    CGFloat offX = locInSelf.x - startPoint.x;
    CGFloat newCenterX = startSelectViewCenter.x + offX;
    newCenterX = MIN(newCenterX, CGRectGetWidth(self.frame) - (CGRectGetWidth(selectBackView.frame) / 2));
    newCenterX = MAX(newCenterX, CGRectGetWidth(selectBackView.frame) / 2);
    CGPoint newCenter = CGPointMake(newCenterX, selectBackView.center.y);
    lastMovedPoint = locInSelf;
    [self slideColorViewCenterToPoint:newCenter];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self slideColorViewToSelectIndex:selectIndex];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self slideColorViewToSelectIndex:selectIndex];
}

- (void)findSelectIndexWithPoint:(CGPoint)point {
    CGFloat width = CGRectGetWidth(self.frame) / [dataSource count];
    selectIndex = point.x / width;
}

- (void)slideColorViewCenterToPoint:(CGPoint)centerPoint {
    selectBackView.center = centerPoint;
    jpMaskView.colorView.frame = selectBackView.frame;
    if (fabs(lastMovedPoint.x - startPoint.x) >= 5) {
        //当点击初始点和最终移动点的X直接距离大于5，才算是移动
        [self findSelectIndexWithPoint:centerPoint];
    }
}

- (void)slideColorViewToSelectIndex:(NSUInteger)index {
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    NSLog(@"%lu",(unsigned long)selectIndex);
    UILabel *tapLabel = [dataSource objectAtIndex:selectIndex];
    NSTimeInterval animationTime = _segmentedControlAnimation == JPSegmentControlAnimationSlide ? 0.2 : 0;
    if (_segmentedControlStyle == JPSegmentControlStyleFill) {
        [UIView animateWithDuration:animationTime animations:^{
            selectBackView.center = CGPointMake(tapLabel.center.x, selectBackView.center.y);
            jpMaskView.colorView.frame = selectBackView.frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

//- (id)init {
//    self = [super init];
//    if (self) {
//        [self setupBase];
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBase];
    }
    return self;
}

- (void)setupBase {
    _backColor = [UIColor whiteColor];
    _selectColor = [UIColor colorWithRed:0.137 green:0.317 blue:1.000 alpha:1.000];
    dataSource = [[NSMutableArray alloc] init];
    selectBackView = [[UIView alloc] init];
    selectBackView.backgroundColor = self.selectColor;
    [self addSubview:selectBackView];
    
    titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor clearColor];
    titlesView.userInteractionEnabled = YES;
    [self addSubview:titlesView];
}

- (void)insertSegmentWithTitles:(NSArray *)titles {
    for (NSString *title in titles) {
        UILabel *createLabel = [self createSegmentWithTitle:title];
        [titlesView addSubview:createLabel];
        [dataSource addObject:createLabel];
    }
    
    int i = 0;
    CGFloat labelWidth = CGRectGetWidth(self.frame) / [dataSource count];
    for (UILabel *currLabel in dataSource) {
        currLabel.frame = CGRectMake(i * labelWidth, 0, labelWidth, CGRectGetHeight(self.frame));
        i++;
    }
    
    titlesView.frame = self.bounds;
    maskImage = [self convertViewToImage:titlesView];
    
    jpMaskView = [[JPSegmentControlMaskView alloc] initWithFrame:self.bounds andMaskImage:maskImage titleCount:[dataSource count]];
    jpMaskView.colorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:jpMaskView];
    [jpMaskView sendSubviewToBack:titlesView];
}

- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    self.backgroundColor = backColor;
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    selectBackView.backgroundColor = selectColor;
}

- (void)setSelectIndex:(NSUInteger)newSelectIndex {
    selectIndex = newSelectIndex;
}

#pragma mark 创建view相关元素

- (id)createSegmentWithTitle:(NSString *)title {
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = title;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor orangeColor];
    lab.font = [UIFont systemFontOfSize:16.0f];
    lab.userInteractionEnabled = YES;
    return lab;
}

#pragma mark set & get

- (NSUInteger)selectIndex {
    return selectIndex;
}

- (NSUInteger)numberOfSegments {
    return [dataSource count];
}

- (UIImage *)convertViewToImage:(UIView *)view {
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_segmentedControlStyle == JPSegmentControlStyleFill) {
        self.layer.borderColor = [UIColor orangeColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        self.backgroundColor = self.backColor;
        UILabel *firstLabel = [dataSource firstObject];
        selectBackView.frame = firstLabel.frame;
    }
}

@end
