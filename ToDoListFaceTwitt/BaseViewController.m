//
//  BaseViewController.m
//  ToDoListFaceTwitt
//
//  Created by Roman on 18.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

@implementation BaseTableViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end