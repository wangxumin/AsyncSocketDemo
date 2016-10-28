//
//  FireViewController.m
//  动画
//
//  Created by 王续敏 on 16/10/20.
//  Copyright © 2016年 Ruanan. All rights reserved.
//

#import "FireViewController.h"

@interface FireViewController ()


@end

@implementation FireViewController
{
    CAEmitterLayer *_fireEmitter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    //设置发射器
    //设置发射器
    _fireEmitter=[[CAEmitterLayer alloc]init];
    _fireEmitter.emitterPosition=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-20);
    _fireEmitter.emitterSize=CGSizeMake(self.view.frame.size.width-100, 20);
    _fireEmitter.renderMode = kCAEmitterLayerAdditive;
    //发射单元
    //火焰
    CAEmitterCell * fire = [CAEmitterCell emitterCell];
    fire.birthRate=800;
    fire.lifetime=2.0;
    fire.lifetimeRange=1.5;
    fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
    fire.contents=(id)[[UIImage imageNamed:@"chat_unlove_pressed"]CGImage];
    [fire setName:@"fire"];
    
    fire.velocity=160;
    fire.velocityRange=80;
    fire.emissionLongitude= M_PI+M_PI_2;
    fire.emissionRange=M_PI_2;
    fire.scaleSpeed=0.3;
    fire.spin=0.2;
    
    //烟雾
    CAEmitterCell * smoke = [CAEmitterCell emitterCell];
    smoke.birthRate=400;
    smoke.lifetime=3.0;
    smoke.lifetimeRange=1.5;
    smoke.color=[[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05]CGColor];
    smoke.contents=(id)[[UIImage imageNamed:@"chat_unlove_pressed"]CGImage];
    [fire setName:@"smoke"];
    smoke.velocity=250;
    smoke.velocityRange=100;
    smoke.emissionLongitude=M_PI+M_PI_2;
    smoke.emissionRange=M_PI_2;
    
    _fireEmitter.emitterCells=[NSArray arrayWithObjects:smoke,fire,nil];
    [self.view.layer addSublayer:_fireEmitter];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
