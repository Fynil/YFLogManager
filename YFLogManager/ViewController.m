//
//  ViewController.m
//  YFLogManager
//
//  Created by Fynil on 2018/7/16.
//  Copyright © 2018年 Fynil. All rights reserved.
//

#import "ViewController.h"
#import "YFLOGManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[YFLOGManager defaultManager] registerLogMgr];
}

- (IBAction)logAction:(id)sender {
    YFLog(@"%@",@"Test Log Manager");
}

- (IBAction)checkAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checkLog" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
