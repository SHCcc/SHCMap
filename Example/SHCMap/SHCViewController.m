//
//  SHCViewController.m
//  SHCMap
//
//  Created by 578013836@qq.com on 03/27/2018.
//  Copyright (c) 2018 578013836@qq.com. All rights reserved.
//

#import "SHCViewController.h"

@interface SHCViewController () <UITableViewDelegate>

@end

@implementation SHCViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
}
- (IBAction)pushEvent:(id)sender {
  [self.navigationController pushViewController: [SHCMapViewController new] animated: true];
}
  
@end
