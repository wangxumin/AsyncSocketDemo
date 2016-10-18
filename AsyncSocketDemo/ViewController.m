//
//  ViewController.m
//  AsyncSocketDemo
//
//  Created by 王续敏 on 16/10/18.
//  Copyright © 2016年 Ruanan. All rights reserved.
//

#import "ViewController.h"
#import "XMSocketManager.h"
@interface ViewController ()<ProtocolsDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [XMSocketManager sharedInstance].delegate = self;
}

#pragma ========ProtocolsDelegate======
- (void)sendDataToViewcontroller:(Protocols *)protocols{
    
    NSLog(@"====%@",protocols);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
