//
//  ViewController.m
//  动画
//
//  Created by 王续敏 on 16/10/20.
//  Copyright © 2016年 Ruanan. All rights reserved.
//

#import "ViewController.h"
#import "FireViewController.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *animateButton;
@property (weak, nonatomic) IBOutlet UIButton *diaoluoButton;
@property (weak, nonatomic) IBOutlet UIButton *transButton;

@end

@implementation ViewController


- (IBAction)buttonAction:(UIButton *)sender {
    
    FireViewController *fireVC = [FireViewController new];
    [self.navigationController pushViewController:fireVC animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //呼吸动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.autoreverses = YES; //回退动画（动画可逆，即循环）
    animation.duration = 1.0;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;//removedOnCompletion,fillMode配合使用保持动画完成效果
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.animateButton.layer addAnimation:animation forKey:@"aAlpha"];
    //摇摆动画
    self.diaoluoButton.layer.anchorPoint = CGPointMake(0.5, 0.0);
    CABasicAnimation *rotaionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotaionAnimation.fromValue = @(1.0);
    rotaionAnimation.toValue = @(-1.0);
    rotaionAnimation.duration = 1.5;
    rotaionAnimation.repeatCount = MAXFLOAT;
    rotaionAnimation.autoreverses = YES;
    rotaionAnimation.removedOnCompletion = NO;
    rotaionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotaionAnimation.fillMode = kCAFillModeBoth;
    [self.diaoluoButton.layer addAnimation:rotaionAnimation forKey:@"revItUpAnimation"];
    
//    //转场动画
//    CATransition *transition = [CATransition animation];
//    transition.repeatCount = MAXFLOAT;
//    transition.type = @"oglFlip";
//    transition.subtype = kCATransitionFromLeft;
//    //    - 确定动画时间
//    transition.duration = 1;
//    //    - 添加动画
//    [self.transButton.layer addAnimation:transition forKey:nil];
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    //    animation.keyPath = @"transform.translation.x";
    keyAnimation.keyPath = @"position.y";
    keyAnimation.values = @[@0, @20, @-20, @20, @0];
    keyAnimation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    keyAnimation.duration = 0.5;
    keyAnimation.additive = YES;
    keyAnimation.repeatCount = MAXFLOAT;
    [self.transButton.layer addAnimation:keyAnimation forKey:@"keyTimes"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
