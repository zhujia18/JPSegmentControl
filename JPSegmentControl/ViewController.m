//
//  ViewController.m
//  JPSegmentControl
//
//  Created by 朱佳鹏 on 15/10/26.
//  Copyright © 2015年 Jasper. All rights reserved.
//

#import "ViewController.h"
#import "JPSegmentControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    JPSegmentControl *segmentControl = [[JPSegmentControl alloc] init];
    segmentControl.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 150) / 2, (CGRectGetHeight(self.view.frame) - 30) / 2, 150, 30);
    [segmentControl insertSegmentWithTitles:[NSArray arrayWithObjects:@"投票", @"问题", nil]];
    segmentControl.segmentedControlStyle = JPSegmentControlStyleFill;
    segmentControl.segmentedControlAnimation = JPSegmentControlAnimationSlide;
    segmentControl.selectColor = [UIColor colorWithRed:254/255.0f green:100/255.0f blue:0/255.0f alpha:1];
    [segmentControl addTarget:self action:@selector(questionListSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
}

-(void)questionListSegment:(JPSegmentControl*)segment{
    NSLog(@"selectIndex : %lu",(unsigned long)segment.selectIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
