//
//  ViewController.m
//  iOSHomeWork
//
//  Created by Harry Tormey on 12/1/16.
//  Copyright © 2016 Harry Tormey. All rights reserved.
//

#import "ViewController.h"
#import "iOSHomeWork-swift.h"


@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidLayoutSubviews {
    MainViewController* mainViewController = [[MainViewController alloc] init];
    [self presentViewController:mainViewController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
