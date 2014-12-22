//
//  ToDoModels.m
//  ToDoListFaceTwitt
//
//  Created by Roman on 20.12.14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "ToDoModels.h"
#import <PFObject+Subclass.h>

@implementation ToDoModels
+ (void)load{
    
    [ToDoModels registerSubclass];
}

+ (NSString *)parseClassName{
    
    
    return @"ToDo";
}


@end
