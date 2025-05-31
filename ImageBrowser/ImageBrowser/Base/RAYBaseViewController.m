//
//  RAYBaseViewController.m
//  demo
//
//  Created by fumi on 2019/4/12.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "RAYBaseViewController.h"

@interface RAYBaseViewController ()

@end

@implementation RAYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


+ (instancetype)loadFromNib {    
    return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}
@end
