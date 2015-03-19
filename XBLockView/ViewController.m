//
//  ViewController.m
//  XBLockView
//
//  Created by Peter on 15/3/19.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "ViewController.h"
#import "XBLockView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XBLockView* lock = [[XBLockView alloc] initWithSize:self.view.bounds hor:3 ver:3];
    [self.view addSubview:lock];
}


@end
