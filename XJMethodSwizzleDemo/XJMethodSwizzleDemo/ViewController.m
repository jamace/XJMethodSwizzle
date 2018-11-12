//
//  ViewController.m
//  XJMethodSwizzleDemo
//
//  Created by jamace on 2018/11/12.
//  Copyright © 2018年 com.jamace.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    //执行该方法会调用xj_viewDidAppear方法，后面才会调用该方法
    [super viewDidAppear:animated];
}
@end
