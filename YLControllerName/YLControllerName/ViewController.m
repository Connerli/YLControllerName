//
//  ViewController.m
//  YLControllerName
//
//  Created by Conner on 2018/12/5.
//  Copyright © 2018 Conner. All rights reserved.
//

#import "ViewController.h"
#import "YLChildViewController.h"

@interface ViewController ()
@property (nonatomic, strong) YLChildViewController *childVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
}

#pragma mark - Init
- (void)initUI {
    [self addChildViewController:self.childVC];
    self.childVC.view.frame = self.view.bounds;
    [self.view addSubview:self.childVC.view];
}

#pragma mark - Lazy Load
- (YLChildViewController *)childVC {
    if (!_childVC) {
        _childVC = [[YLChildViewController alloc] init];
    }
    return _childVC;
}

@end
